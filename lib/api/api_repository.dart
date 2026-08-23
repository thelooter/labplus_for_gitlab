import 'dart:async';
import 'package:dio/dio.dart';
import 'package:labplus_for_gitlab/models/models.dart';
import 'package:labplus_for_gitlab/models/request/access_token_request_password.dart';
import 'package:labplus_for_gitlab/models/request/latest_pipeline_request.dart';
import 'package:labplus_for_gitlab/models/request/pipeline_jobs_request.dart';

import 'api.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final ApiProvider apiProvider;

  /// Runs one request and turns anything that goes wrong into a [Failure].
  ///
  /// This is where `DioException` stops being an exception. Every method in
  /// this class used to let it fly, so failure handling lived in
  /// `HttpController`'s `catch` and was invisible in the signatures. Now the
  /// return type says a call can fail, and the compiler makes callers deal
  /// with it.
  ///
  /// The old bodies also guarded on `res.statusCode == 200` and returned null
  /// otherwise. That guard was doing harm rather than good: Dio's default
  /// `validateStatus` already routes every non-2xx to `onError`, so the only
  /// codes it could ever reject were the other successes — 201 Created and
  /// 204 No Content, which is exactly what GitLab returns from the create and
  /// delete endpoints. Those guards are gone; a 2xx that reaches here is a
  /// success.
  Future<ApiResult<T>> _guard<T>(Future<T> Function() request) async {
    try {
      return Ok(await request());
    } on DioException catch (e) {
      return Failure(ApiError.fromDio(e));
    } catch (e) {
      return Failure(ApiError(message: e.toString(), cause: e));
    }
  }

  /// ## Sign in with password
  ///
  /// This method sends a POST request to the GitLab API to sign in with a password.
  /// It returns an [AccessTokenResponse] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `POST /oauth/token` [Docs](https://docs.gitlab.com/ee/api/oauth2.html#resource-owner-password-credentials-grant)
  ///
  ///
  /// ### Parameters
  /// - [data] - [AccessTokenReqestPassword] object
  ///
  /// ###  See also
  /// - [ApiRepository.accessToken]
  Future<ApiResult<AccessTokenResponse>> signInPassword(
      AccessTokenReqestPassword data) async {
    return _guard(() async {
      final res = await apiProvider.accessTokenPassword('/oauth/token', data);
      return AccessTokenResponse.fromJson(res.data);
    });
  }

  /// ## Sign in with access token
  ///
  /// This method sends a POST request to the GitLab API to sign in with a access token.
  /// It returns an [AccessTokenResponse] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `POST /oauth/token` [Docs](https://docs.gitlab.com/ee/api/oauth2.html#resource-owner-password-credentials-grant)
  ///
  /// ### Parameters
  /// - [data] - [AccessTokenReqest] object
  ///
  /// ###  See also
  /// - [ApiRepository.signInPassword]
  Future<ApiResult<AccessTokenResponse>> accessToken(AccessTokenReqest data) async {
    return _guard(() async {
      final res = await apiProvider.accessToken('/oauth/token', data);
      return AccessTokenResponse.fromJson(res.data);
    });
  }

  /// ## Refresh token
  ///
  /// This method sends a POST request to the GitLab API to refresh a token.
  /// It returns an [AccessTokenResponse] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `POST /oauth/token` [Docs](https://docs.gitlab.com/ee/api/oauth2.html#resource-owner-password-credentials-grant)
  ///
  /// ### Parameters
  /// - [data] - [RefreshTokenRequest] object
  ///
  /// ###  See also
  /// - [ApiRepository.signInPassword]
  /// - [ApiRepository.accessToken]
  Future<ApiResult<AccessTokenResponse>> refreshToken(RefreshTokenRequest data) async {
    return _guard(() async {
      final res = await apiProvider.refreshToken('/oauth/token', data);
      return AccessTokenResponse.fromJson(res.data);
    });
  }

  /// ## List users
  ///
  /// This method sends a GET request to the GitLab API to list users.
  /// It returns an [PagingResponse<User>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/users` [Docs](https://docs.gitlab.com/ee/api/users.html#list-users)
  ///
  /// ### Parameters
  /// - [data] - [FindUsersRequest] object
  Future<ApiResult<PagingResponse<User>>> listUsers(FindUsersRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listUsers('/api/v4/users', data);
      var items = <User>[];
      for (var item in res.data) {
        items.add(User.fromJson(item));
      }
      return constructResponse<User>(res, items);
    });
  }

  /// ## Get user
  ///
  /// This method sends a GET request to the GitLab API to get the current user.
  /// It returns an [User] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/user` [Docs](https://docs.gitlab.com/ee/api/users.html#list-current-user)
  Future<ApiResult<User>> getUser() async {
    return _guard(() async {
      final res = await apiProvider.getUser('/api/v4/user');
      return User.fromJson(res.data);
    });
  }

  /// ## List projects
  ///
  /// This method sends a GET request to the GitLab API to list the projects the current user has access to.
  /// It returns an [PagingResponse<Project>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/projects` [Docs](https://docs.gitlab.com/ee/api/projects.html#list-all-projects)
  ///
  /// ### Parameters
  /// - [data] - [ProjectsRequest] object
  Future<ApiResult<PagingResponse<Project>>> listProjects(ProjectsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listProjects('/api/v4/projects', data);
      var items = <Project>[];
      for (var item in res.data) {
        items.add(Project.fromJson(item));
      }
      return constructResponse<Project>(res, items);
    });
  }

  /// ## Get specific project
  ///
  /// This method sends a GET request to the GitLab API to get a specific project.
  /// It returns an [Project] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/project/{id}` [Docs](https://docs.gitlab.com/ee/api/projects.html#get-single-project)
  ///
  /// ### Parameters
  /// - [data] - [ProjectRequest] object
  Future<ApiResult<Project>> getProject(int id, ProjectRequest data) async {
    return _guard(() async {
      final res = await apiProvider.getProject('/api/v4/projects/$id', data);
      return Project.fromJson(res.data);
    });
  }

  /// ## Update project
  ///
  /// This method sends a PUT request to the GitLab API to update a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// `PUT /api/v4/projects/{id}` [Docs](https://docs.gitlab.com/ee/api/projects.html#edit-project)
  Future<ApiResult<void>> updateProject(int projectId, CreateProjectRequest data) async {
    return _guard<void>(() async {
          await apiProvider.updateProject('/api/v4/projects/$projectId', data);
    });
  }

  /// ## Create project
  ///
  /// This method sends a POST request to the GitLab API to create a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// `POST /api/v4/projects` [Docs](https://docs.gitlab.com/ee/api/projects.html#create-project)
  ///
  /// ### Parameters
  /// - [data] - [CreateProjectRequest] object
  Future<ApiResult<void>> createProject(CreateProjectRequest data) async {
    return _guard<void>(() async {
      await apiProvider.createProject('/api/v4/projects', data);
    });
  }

  /// ## Delete project
  ///
  /// This method sends a DELETE request to the GitLab API to delete a project.
  /// It returns an [Project] object if the request is successful, otherwise it returns null.
  /// The project is not actually deleted immediately, but after a short period of time.
  ///
  /// ### Endpoint
  /// `DELETE /api/v4/projects/{id}` [Docs](https://docs.gitlab.com/ee/api/projects.html#delete-a-project)
  Future<ApiResult<Project>> deleteProject(int id) async {
    return _guard(() async {
      final res = await apiProvider.deleteProject('/api/v4/projects/$id');
      return Project.fromJson(res.data);
    });
  }

  /// ## Star project
  ///
  /// This method sends a POST request to the GitLab API to star a project.
  ///
  /// ### Endpoint
  /// `POST /api/v4/projects/{id}/star` [Docs](https://docs.gitlab.com/ee/api/projects.html#star-a-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the project
  Future<ApiResult<void>> starProject(int id) async {
    return _guard<void>(() async {
      await apiProvider.starUnstarProject('/api/v4/projects/$id/star');
    });
  }

  /// ## Unstar project
  ///
  /// This method sends a POST request to the GitLab API to unstar a project.
  ///
  /// ### Endpoint
  /// `POST /api/v4/projects/{id}/unstar` [Docs](https://docs.gitlab.com/ee/api/projects.html#unstar-a-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the project
  Future<ApiResult<void>> unstarProject(int id) async {
    return _guard<void>(() async {
      await apiProvider.starUnstarProject('/api/v4/projects/$id/unstar');
    });
  }

  /// ## List project starrers
  ///
  /// This method sends a GET request to the GitLab API to list the users who have starred a project.
  /// It returns an [PagingResponse<Starrer>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/projects/{id}/starrers` [Docs](https://docs.gitlab.com/ee/api/projects.html#list-starrers-of-a-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the project
  /// - [data] - [StarrersRequest] object
  Future<ApiResult<PagingResponse<Starrer>>> listProjectStarrers(
      int id, StarrersRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listProjectStarrers(
        '/api/v4/projects/$id/starrers', data);
      var items = <Starrer>[];
      for (var item in res.data) {
        items.add(Starrer.fromJson(item));
      }
      return constructResponse<Starrer>(res, items);
    });
  }

  /// ## List branches
  ///
  /// This method sends a GET request to the GitLab API to list the branches of a project.
  /// It returns an [PagingResponse<Branch>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{id}/repository/branches [Docs](https://docs.gitlab.com/ee/api/branches.html#list-repository-branches)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [BranchesRequest] object
  Future<ApiResult<PagingResponse<Branch>>> listBranches(
      int projectId, BranchesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listBranches(
        '/api/v4/projects/$projectId/repository/branches', data);
      var items = <Branch>[];
      for (var item in res.data) {
        items.add(Branch.fromJson(item));
      }
      return constructResponse<Branch>(res, items);
    });
  }

  /// ## Get tags
  ///
  /// This method sends a GET request to the GitLab API to get the tags of a project.
  /// It returns an [PagingResponse<Tag>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{id}/repository/tags [Docs](https://docs.gitlab.com/ee/api/tags.html#list-project-repository-tags)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [TagsRequest] object
  Future<ApiResult<PagingResponse<Tag>>> listTags(int id, TagsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listTags(
        '/api/v4/projects/$id/repository/tags', data);
      var items = <Tag>[];
      for (var item in res.data) {
        items.add(Tag.fromJson(item));
      }
      return constructResponse<Tag>(res, items);
    });
  }

  /// ## Get repository tree
  ///
  /// This method sends a GET request to the GitLab API to get the tree of a project repository.
  /// It returns an [PagingResponse<Tree>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{id}/repository/tree [Docs](https://docs.gitlab.com/ee/api/repositories.html#list-repository-tree)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [TreeRequest] object
  Future<ApiResult<PagingResponse<Tree>>> listRepositoryTree(
      int id, TreeRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listRepositoryTree(
        '/api/v4/projects/$id/repository/tree', data);
      var items = <Tree>[];
      for (var item in res.data) {
        items.add(Tree.fromJson(item));
      }
      return constructResponse<Tree>(res, items);
    });
  }

  /// ## Get file
  ///
  /// This method sends a GET request to the GitLab API to get a file from a project repository.
  /// It returns an [File] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/repository/files/{filePath} [Docs](https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [filePath] - The path to the file
  /// - [data] - [FileRequest] object
  Future<ApiResult<File>> getFile(
      int projectId, String filePath, FileRequest data) async {
    return _guard(() async {
      var encoded = Uri.encodeComponent(filePath);
      final res = await apiProvider.getFile(
        '/api/v4/projects/$projectId/repository/files/$encoded', data);
      return File.fromJson(res.data);
    });
  }

  /// ## Get project members
  ///
  /// This method sends a GET request to the GitLab API to get the members of a project.
  /// It returns an [PagingResponse<Member>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{id}/members [Docs](https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the project
  /// - [data] - [MembersRequest] object
  Future<ApiResult<PagingResponse<Member>>> listProjectMembers(
      int id, MembersRequest data) async {
    return _guard(() async {
      final res =
        await apiProvider.listMembers('/api/v4/projects/$id/members', data);
      var items = <Member>[];
      for (var item in res.data) {
        items.add(Member.fromJson(item));
      }
      return constructResponse<Member>(res, items);
    });
  }

  /// ## Add project member
  ///
  /// This method sends a POST request to the GitLab API to add a member to a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{id}/members [Docs](https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the project
  /// - [data] - [AddMemberRequest] object
  Future<ApiResult<void>> addProjectMember(int id, AddMemberRequest data) async {
    return _guard<void>(() async {
          await apiProvider.addMember('/api/v4/projects/$id/members', data);
    });
  }

  /// ## Remove project member
  ///
  /// This method sends a DELETE request to the GitLab API to remove a member from a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/members/{memberId} [Docs](https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [memberId] - The ID of the member
  Future<ApiResult<void>> removeProjectMember(int projectId, int memberId) async {
    return _guard<void>(() async {
      await apiProvider
          .removeMember('/api/v4/projects/$projectId/members/$memberId');
    });
  }

  /// ## List groups
  ///
  /// This method sends a GET request to the GitLab API to list groups.
  /// It returns an [PagingResponse<Group>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/groups [Docs](https://docs.gitlab.com/ee/api/groups.html#list-groups)
  ///
  /// ### Parameters
  /// - [data] - [GroupsRequest] object
  Future<ApiResult<PagingResponse<Group>>> listGroups(GroupsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listGroups('/api/v4/groups', data);
      var items = <Group>[];
      for (var item in res.data) {
        items.add(Group.fromJson(item));
      }
      return constructResponse<Group>(res, items);
    });
  }

  /// ## Add group
  ///
  /// This method sends a POST request to the GitLab API to add a group.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/groups [Docs](https://docs.gitlab.com/ee/api/groups.html#new-group)
  ///
  /// ### Parameters
  /// - [data] - [AddGroupRequest] object
  Future<ApiResult<void>> addGroup(AddGroupRequest data) async {
    return _guard<void>(() async {
      await apiProvider.addGroup('/api/v4/groups', data);
    });
  }

  /// ## List group projects
  ///
  /// This method sends a GET request to the GitLab API to list the projects of a group.
  /// It returns an [PagingResponse<Project>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/groups/{id}/projects [Docs](https://docs.gitlab.com/ee/api/groups.html#list-a-groups-projects)
  ///
  /// ### Parameters
  /// - [groupId] - The ID of the group
  /// - [data] - [GroupProjectsRequest] object
  Future<ApiResult<PagingResponse<Project>>> listGroupProjects(
      int groupId, GroupProjectsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listGroupProjects(
        '/api/v4/groups/$groupId/projects', data);
      var items = <Project>[];
      for (var item in res.data) {
        items.add(Project.fromJson(item));
      }
      return constructResponse<Project>(res, items);
    });
  }

  /// ## List group members
  ///
  /// This method sends a GET request to the GitLab API to list the members of a group.
  /// It returns an [PagingResponse<Member>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/groups/{id}/members [Docs](https://docs.gitlab.com/ee/api/members.html#list-all-members-of-a-group-or-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the group
  /// - [data] - [MembersRequest] object
  Future<ApiResult<PagingResponse<Member>>> listGroupMembers(
      int id, MembersRequest data) async {
    return _guard(() async {
      final res =
        await apiProvider.listMembers('/api/v4/groups/$id/members', data);
      var items = <Member>[];
      for (var item in res.data) {
        items.add(Member.fromJson(item));
      }
      return constructResponse<Member>(res, items);
    });
  }

  /// ## Add group member
  ///
  /// This method sends a POST request to the GitLab API to add a member to a group.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/groups/{id}/members [Docs](https://docs.gitlab.com/ee/api/members.html#add-a-member-to-a-group-or-project)
  ///
  /// ### Parameters
  /// - [id] - The ID of the group
  /// - [data] - [AddMemberRequest] object
  Future<ApiResult<void>> addGroupMember(int id, AddMemberRequest data) async {
    return _guard<void>(() async {
      await apiProvider.addMember('/api/v4/groups/$id/members', data);
    });
  }

  /// ## Remove group member
  ///
  /// This method sends a DELETE request to the GitLab API to remove a member from a group.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/groups/{groupId}/members/{memberId} [Docs](https://docs.gitlab.com/ee/api/members.html#remove-a-member-from-a-group-or-project)
  ///
  /// ### Parameters
  /// - [groupId] - The ID of the group
  /// - [memberId] - The ID of the member
  Future<ApiResult<void>> removeGroupMember(int groupId, int memberId) async {
    return _guard<void>(() async {
      await apiProvider
          .removeGroupMember('/api/v4/groups/$groupId/members/$memberId');
    });
  }

  /// ## List commits
  ///
  /// This method sends a GET request to the GitLab API to list the commits of a project.
  ///
  /// It returns an [PagingResponse<Commit>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{id}/repository/commits [Docs](https://docs.gitlab.com/ee/api/commits.html#list-repository-commits)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [CommitsReqest] object
  Future<ApiResult<PagingResponse<Commit>>> listCommits(
      int projectId, CommitsReqest data) async {
    return _guard(() async {
      final res = await apiProvider.listCommits(
        '/api/v4/projects/$projectId/repository/commits', data);
      var items = <Commit>[];
      for (var item in res.data) {
        items.add(Commit.fromJson(item));
      }
      return constructResponse<Commit>(res, items);
    });
  }

  /// ## Get commit
  ///
  /// This method sends a GET request to the GitLab API to get a commit of a project.
  /// It returns an [Commit] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/repository/commits/{sha} [Docs](https://docs.gitlab.com/ee/api/commits.html#get-a-single-commit)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [sha] - The SHA of the commit
  /// - [data] - [CommitReqest] object
  Future<ApiResult<Commit>> getCommit(
      int projectId, String sha, CommitReqest data) async {
    return _guard(() async {
      final res = await apiProvider.getCommit(
        '/api/v4/projects/$projectId/repository/commits/$sha', data);
      return Commit.fromJson(res.data);
    });
  }

  /// ## Get diff
  ///
  /// This method sends a GET request to the GitLab API to get the diff of a commit.
  /// It returns an [PagingResponse<Diff>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/repository/commits/{sha}/diff [Docs](https://docs.gitlab.com/ee/api/commits.html#get-the-diff-of-a-commit)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [sha] - The SHA of the commit
  /// - [data] - [DiffRequest] object
  Future<ApiResult<PagingResponse<Diff>>> getDiff(
      int projectId, String sha, DiffRequest data) async {
    return _guard(() async {
      final res = await apiProvider.getDiff(
        '/api/v4/projects/$projectId/repository/commits/$sha/diff', data);
      var items = <Diff>[];
      for (var item in res.data) {
        items.add(Diff.fromJson(item));
      }
      return constructResponse<Diff>(res, items);
    });
  }

  /// ## List issues
  ///
  /// This method sends a GET request to the GitLab API to list all the issues a user has access to.
  /// It returns an [PagingResponse<Issue>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/issues [Docs](https://docs.gitlab.com/ee/api/issues.html#list-issues)
  ///
  /// ### Parameters
  /// - [data] - [IssuesRequest] object
  Future<ApiResult<PagingResponse<Issue>>> listIssues(IssuesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listIssues('/api/v4/issues', data);
      var items = <Issue>[];
      for (var item in res.data) {
        items.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, items);
    });
  }

  /// ## Get issue
  ///
  /// This method sends a GET request to the GitLab API to get an issue of a project.
  /// It returns an [Issue] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/issues/{iid} [Docs](https://docs.gitlab.com/ee/api/issues.html#single-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [IssueRequest] object
  Future<ApiResult<PagingResponse<Issue>>> listProjectIssues(
      int projectId, IssuesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listIssues(
        '/api/v4/projects/$projectId/issues', data);
      var items = <Issue>[];
      for (var item in res.data) {
        items.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, items);
    });
  }

  /// ## Get issue
  ///
  /// This method sends a GET request to the GitLab API to get an issue of a project.
  /// It returns an [Issue] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/issues/{iid} [Docs](https://docs.gitlab.com/ee/api/issues.html#single-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [iid] - The IID of the issue
  Future<ApiResult<Issue>> getProjectIssue(int projectId, int iid) async {
    return _guard(() async {
      final res =
          await apiProvider.getIssue('/api/v4/projects/$projectId/issues/$iid');
      return Issue.fromJson(res.data);
    });
  }

  /// ## Update issue
  ///
  /// This method sends a PUT request to the GitLab API to update an issue.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/issues/{issueIid} [Docs](https://docs.gitlab.com/ee/api/issues.html#edit-an-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  /// - [data] - [UpdateIssueRequest] object
  Future<ApiResult<void>> updateProjectIssue(
      int projectId, int issueIid, UpdateIssueRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateIssue(
          '/api/v4/projects/$projectId/issues/$issueIid', data);
    });
  }

  /// ## Add issue
  ///
  /// This method sends a POST request to the GitLab API to add an issue to a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/issues [Docs](https://docs.gitlab.com/ee/api/issues.html#new-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [UpdateIssueRequest] object
  Future<ApiResult<void>> addProjectIssue(int projectId, UpdateIssueRequest data) async {
    return _guard<void>(() async {
          await apiProvider.addIssue('/api/v4/projects/$projectId/issues', data);
    });
  }

  /// ## Delete issue
  ///
  /// This method sends a DELETE request to the GitLab API to delete an issue.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/issues/{issueId} [Docs](https://docs.gitlab.com/ee/api/issues.html#delete-an-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueId] - The ID of the issue
  Future<ApiResult<void>> deleteProjectIssue(int projectId, int issueId) async {
    return _guard<void>(() async {
      await apiProvider
          .deleteIssue('/api/v4/projects/$projectId/issues/$issueId');
    });
  }

  /// ## List merge requests
  ///
  /// This method sends a GET request to the GitLab API to list all the merge requests a user has access to.
  /// It returns an [PagingResponse<MergeRequest>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/merge_requests [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#list-merge-requests)
  ///
  /// ### Parameters
  /// - [data] - [MergeRequestRequest] object
  Future<ApiResult<PagingResponse<MergeRequest>>> listMergeRequests(
      MergeRequestRequest data) async {
    return _guard(() async {
      final res =
        await apiProvider.listMergeRequests('/api/v4/merge_requests', data);
      var items = <MergeRequest>[];
      for (var item in res.data) {
        items.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, items);
    });
  }

  /// ## List project merge requests
  ///
  /// This method sends a GET request to the GitLab API to list the merge requests of a project.
  /// It returns an [PagingResponse<MergeRequest>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/merge_requests [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#list-project-merge-requests)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [MergeRequestRequest] object
  Future<ApiResult<PagingResponse<MergeRequest>>> listProjectMergeRequests(
      int projectId, MergeRequestRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listMergeRequests(
        '/api/v4/projects/$projectId/merge_requests', data);
      var items = <MergeRequest>[];
      for (var item in res.data) {
        items.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, items);
    });
  }

  /// ## List issue related merge requests
  ///
  /// This method sends a GET request to the GitLab API to list the merge requests related to an issue.
  /// It returns an [PagingResponse<MergeRequest>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/issues/{issueIid}/related_merge_requests [Docs](https://docs.gitlab.com/ee/api/issues.html#list-merge-requests-related-to-issue)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  Future<ApiResult<PagingResponse<MergeRequest>>> listIssueRelatedMergeRequests(
      int projectId, int issueIid) async {
    return _guard(() async {
      final res = await apiProvider.listIssueRelatedMergeRequests(
        '/api/v4/projects/$projectId/issues/$issueIid/related_merge_requests');
      var items = <MergeRequest>[];
      for (var item in res.data) {
        items.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, items);
    });
  }

  /// ## Get merge request
  ///
  /// This method sends a GET request to the GitLab API to get a merge request.
  /// It returns an [DetailedMergeRequest] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/merge_requests/{mrIid} [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [mrIid] - The IID of the merge request
  Future<ApiResult<MergeRequest>> getMergeRequest(int projectId, int mrIid) async {
    return _guard(() async {
      final res = await apiProvider
        .getMergeRequest('/api/v4/projects/$projectId/merge_requests/$mrIid');
      return MergeRequest.fromJson(res.data);
    });
  }

  Future<ApiResult<DetailedMergeRequest>> getDetailedMergeRequest(
      int projectId, int detailedMrIiid) async {
    return _guard(() async {
      final res = await apiProvider.getMergeRequest(
        '/api/v4/projects/$projectId/merge_requests/$detailedMrIiid');
      return DetailedMergeRequest.fromJson(res.data);
    });
  }

  Future<ApiResult<PagingResponse<Note>>> listProjectMergeRequestNotes(
      int projectId, int mergeRequestIid, NotesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listNotes(''
        '/api/v4/projects/$projectId/merge_requests/$mergeRequestIid/notes', data);

      var items = <Note>[];
      for (var item in res.data) {
        items.add(Note.fromJson(item));
      }
      return constructResponse<Note>(res, items);
    });
  }

  /// ## Create merge request
  ///
  /// This method sends a POST request to the GitLab API to create a merge request.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/merge_requests [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#create-mr)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [CreateMRRequest] object
  Future<ApiResult<void>> createMergeRequest(int projectId, CreateMRRequest data) async {
    return _guard<void>(() async {
      await apiProvider.createMergeRequest(
          '/api/v4/projects/$projectId/merge_requests', data);
    });
  }

  /// ## Update merge request
  ///
  /// This method sends a PUT request to the GitLab API to update a merge request.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/merge_requests/{mrIid} [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#update-mr)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [mrIid] - The IID of the merge request
  /// - [data] - [UpdateMRRequest] object
  Future<ApiResult<void>> updateMergeRequest(
      int projectId, int mrIid, UpdateMRRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateMergeRequest(
          '/api/v4/projects/$projectId/merge_requests/$mrIid', data);
    });
  }

  /// ## Delete merge request
  ///
  /// This method sends a DELETE request to the GitLab API to delete a merge request.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/merge_requests/{id} [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#delete-a-merge-request)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [id] - The ID of the merge request
  Future<ApiResult<void>> deleteMergeRequest(int projectId, int id) async {
    return _guard<void>(() async {
      await apiProvider
          .deleteMergeRequest('/api/v4/projects/$projectId/merge_requests/$id');
    });
  }

  /// ## List project labels
  ///
  /// This method sends a GET request to the GitLab API to list the labels of a project.
  /// It returns an [PagingResponse<ProjectLabel>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/labels [Docs](https://docs.gitlab.com/ee/api/labels.html#list-labels)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [ProjectLabelsRequest] object
  Future<ApiResult<PagingResponse<ProjectLabel>>> listProjectLabels(
      int projectId, ProjectLabelsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listProjectLabels(
        '/api/v4/projects/$projectId/labels', data);
      var items = <ProjectLabel>[];
      for (var item in res.data) {
        items.add(ProjectLabel.fromJson(item));
      }
      return constructResponse<ProjectLabel>(res, items);
    });
  }

  /// ## List group labels
  ///
  /// This method sends a GET request to the GitLab API to list the labels of a group.
  /// It returns an [PagingResponse<GroupLabel>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectsId}/labels [Docs](https://docs.gitlab.com/ee/api/labels.html#list-labels)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [GroupLabelsRequest] object
  Future<ApiResult<PagingResponse<GroupLabel>>> listGroupLabels(
      int projectId, GroupLabelsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listGroupLabels(
        '/api/v4/projects/$projectId/labels', data); //FIX Is this correct?
      var items = <GroupLabel>[];
      for (var item in res.data) {
        items.add(GroupLabel.fromJson(item));
      }
      return constructResponse<GroupLabel>(res, items);
    });
  }

  /// ## Create project label
  ///
  /// This method sends a POST request to the GitLab API to create a label for a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/labels [Docs](https://docs.gitlab.com/ee/api/labels.html#create-a-new-label)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [CreateLabelRequest] object
  Future<ApiResult<void>> createProjectLabel(
      int projectId, CreateLabelRequest data) async {
    return _guard<void>(() async {
      await apiProvider.createLabel(
          '/api/v4/projects/$projectId/labels', data);
    });
  }

  /// ## Create group label
  ///
  /// This method sends a POST request to the GitLab API to create a label for a group.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/groups/{groupId}/labels [Docs](https://docs.gitlab.com/ee/api/labels.html#create-a-new-label)
  ///
  /// ### Parameters
  /// - [groupId] - The ID of the group
  /// - [data] - [CreateLabelRequest] object
  Future<ApiResult<void>> createGroupLabel(int groupId, CreateLabelRequest data) async {
    return _guard<void>(() async {
          await apiProvider.createLabel('/api/v4/groups/$groupId/labels', data);
    });
  }

  /// ## Update project label
  ///
  /// This method sends a PUT request to the GitLab API to update a label of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/labels/{labelId} [Docs](https://docs.gitlab.com/ee/api/labels.html#edit-an-existing-label)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [labelId] - The ID of the label
  /// - [data] - [UpdateProjectLabelRequest] object
  Future<ApiResult<void>> updateProjectLabel(
      int projectId, int labelId, UpdateProjectLabelRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateProjectLabel(
          '/api/v4/projects/$projectId/labels/$labelId', data);
    });
  }

  /// ## Delete project label
  ///
  /// This method sends a DELETE request to the GitLab API to delete a label of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/labels/{labelId} [Docs](https://docs.gitlab.com/ee/api/labels.html#delete-a-label)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [labelId] - The ID of the label
  Future<ApiResult<void>> deleteProjectLabel(int projectId, int labelId) async {
    return _guard<void>(() async {
      await apiProvider
          .deleteLabel('/api/v4/projects/$projectId/labels/$labelId');
    });
  }

  /// ## List snippets
  ///
  /// This method sends a GET request to the GitLab API to list all the snippets a user has access to.
  /// It returns an [PagingResponse<Snippet>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/snippets [Docs](https://docs.gitlab.com/ee/api/snippets.html#list-all-snippets-for-current-user)
  ///
  /// ### Parameters
  /// - [data] - [SnippetsRequest] object
  Future<ApiResult<PagingResponse<Snippet>>> listSnippets(SnippetsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listSnippets('/api/v4/snippets', data);
      var items = <Snippet>[];
      for (var item in res.data) {
        items.add(Snippet.fromJson(item));
      }
      return constructResponse<Snippet>(res, items);
    });
  }

  /// ## List project snippets
  ///
  /// This method sends a GET request to the GitLab API to list the snippets of a project.
  /// It returns an [PagingResponse<ProjectSnippet>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/snippets [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#list-snippets)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [SnippetsRequest] object
  Future<ApiResult<PagingResponse<ProjectSnippet>>> listProjectSnippets(
      int projectId, SnippetsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listSnippets(
        '/api/v4/projects/$projectId/snippets', data);
      var items = <ProjectSnippet>[];
      for (var item in res.data) {
        items.add(ProjectSnippet.fromJson(item));
      }
      return constructResponse<ProjectSnippet>(res, items);
    });
  }

  /// ## Get specific project snippet
  ///
  /// This method sends a GET request to the GitLab API to get a specific snippet of a project.
  /// It returns a [ProjectSnippet] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/snippets/{snippetId} [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#single-snippet)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [snippetId] - The ID of the snippet
  Future<ApiResult<ProjectSnippet>> getProjectSnippet(
      int projectId, int snippetId) async {
    return _guard(() async {
      final res = await apiProvider
        .getSnippet('/api/v4/projects/$projectId/snippets/$snippetId');
      return ProjectSnippet.fromJson(res.data);
    });
  }

  /// ## Get project snippet content
  ///
  /// This method sends a GET request to the GitLab API to get the content of a specific snippet of a project.
  /// It returns a [String] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/snippets/{snippetId}/raw [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#snippet-content)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [snippetId] - The ID of the snippet
  Future<ApiResult<String>> getProjectSnippetContent(int projectId, int snippetId) async {
    return _guard(() async {
      final res = await apiProvider.getSnippetContent(
        '/api/v4/projects/$projectId/snippets/$snippetId/raw');
      return res.data;
    });
  }

  /// ## Add project snippet
  ///
  /// This method sends a POST request to the GitLab API to add a snippet to a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/snippets [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#create-new-snippet)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [AddUpdateSnippetRequest] object
  Future<ApiResult<void>> addProjectSnippet(
      int projectId, AddUpdateSnippetRequest data) async {
    return _guard<void>(() async {
      await apiProvider.addSnippet(
          '/api/v4/projects/$projectId/snippets', data);
    });
  }

  /// ## Update project snippet
  ///
  /// This method sends a PUT request to the GitLab API to update a snippet of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/snippets/{snippetId} [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#update-snippet)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [snippetId] - The ID of the snippet
  /// - [data] - [AddUpdateSnippetRequest] object
  Future<ApiResult<void>> updateProjectSnippet(
      int projectId, int snippetId, AddUpdateSnippetRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateSnippet(
          '/api/v4/projects/$projectId/snippets/$snippetId', data);
    });
  }

  /// ## Delete project snippet
  ///
  /// This method sends a DELETE request to the GitLab API to delete a snippet of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/snippets/{snippetId} [Docs](https://docs.gitlab.com/ee/api/project_snippets.html#delete-snippet)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [snippetId] - The ID of the snippet
  Future<ApiResult<void>> deleteProjectSnippet(int projectId, int snippetId) async {
    return _guard<void>(() async {
      await apiProvider
          .deleteSnippet('/api/v4/projects/$projectId/snippets/$snippetId');
    });
  }

  /// ## List project milestones
  ///
  /// This method sends a GET request to the GitLab API to list the milestones of a project.
  /// It returns an [PagingResponse<ProjectMilestone>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/milestones [Docs](https://docs.gitlab.com/ee/api/milestones.html#list-project-milestones)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [MilestonesRequest] object
  Future<ApiResult<PagingResponse<ProjectMilestone>>> listProjectMilestones(
      int projectId, MilestonesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listMilestones(
        '/api/v4/projects/$projectId/milestones', data);
      var items = <ProjectMilestone>[];
      for (var item in res.data) {
        items.add(ProjectMilestone.fromJson(item));
      }
      return constructResponse<ProjectMilestone>(res, items);
    });
  }

  /// ## Get project milestone
  ///
  /// This method sends a GET request to the GitLab API to get a milestone of a project.
  /// It returns a [ProjectMilestone] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/milestones/{milestoneId} [Docs](https://docs.gitlab.com/ee/api/milestones.html#get-single-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [milestoneId] - The ID of the milestone
  Future<ApiResult<ProjectMilestone>> getProjectMilestone(
      int projectId, int milestoneId) async {
    return _guard(() async {
      final res = await apiProvider
        .getMilestone('/api/v4/projects/$projectId/milestones/$milestoneId');
      return ProjectMilestone.fromJson(res.data);
    });
  }

  /// ## Update project milestone
  ///
  /// This method sends a PUT request to the GitLab API to update a milestone of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/milestones/{milestoneId} [Docs](https://docs.gitlab.com/ee/api/milestones.html#edit-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [milestoneId] - The ID of the milestone
  /// - [data] - [AddUpdateMilestoneRequest] object
  Future<ApiResult<void>> updateProjectMilestone(
      int projectId, int milestoneId, AddUpdateMilestoneRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateProjectMilestone(
          '/api/v4/projects/$projectId/milestones/$milestoneId', data);
    });
  }

  /// ## Add project milestone
  ///
  /// This method sends a POST request to the GitLab API to add a milestone to a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/milestones [Docs](https://docs.gitlab.com/ee/api/milestones.html#create-new-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [AddUpdateMilestoneRequest] object
  Future<ApiResult<void>> addProjectMilestone(
      int projectId, AddUpdateMilestoneRequest data) async {
    return _guard<void>(() async {
      await apiProvider.addProjectMilestone(
          '/api/v4/projects/$projectId/milestones', data);
    });
  }

  /// ## Delete project milestone
  ///
  /// This method sends a DELETE request to the GitLab API to delete a milestone of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/milestones/{milestoneId} [Docs](https://docs.gitlab.com/ee/api/milestones.html#delete-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [milestoneId] - The ID of the milestone
  Future<ApiResult<void>> deleteProjectMilestone(int projectId, int milestoneId) async {
    return _guard<void>(() async {
      await apiProvider.deleteProjectMilestone(
          '/api/v4/projects/$projectId/milestones/$milestoneId');
    });
  }

  /// ## List project milestone issues
  ///
  /// This method sends a GET request to the GitLab API to list the issues of a milestone of a project.
  /// It returns an [PagingResponse<Issue>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/milestones/{milestoneId}/issues [Docs](https://docs.gitlab.com/ee/api/milestones.html#get-all-issues-assigned-to-a-single-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [milestoneId] - The ID of the milestone
  Future<ApiResult<PagingResponse<Issue>>> getMilestoneIssues(
      int projectId, int milestoneId) async {
    return _guard(() async {
      final res = await apiProvider.getMilestoneIssues(
        '/api/v4/projects/$projectId/milestones/$milestoneId/issues');
      var items = <Issue>[];
      for (var item in res.data) {
        items.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, items);
    });
  }

  /// ## List project milestone merge requests
  ///
  /// This method sends a GET request to the GitLab API to list the merge requests of a milestone of a project.
  /// It returns an [PagingResponse<MergeRequest>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/milestones/{milestoneId}/merge_requests [Docs](https://docs.gitlab.com/ee/api/milestones.html#get-all-merge-requests-assigned-to-a-single-milestone)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [milestoneId] - The ID of the milestone
  Future<ApiResult<PagingResponse<MergeRequest>>> getMilestoneMR(
      int projectId, int milestoneId) async {
    return _guard(() async {
      final res = await apiProvider.getMilestoneMR(
        '/api/v4/projects/$projectId/milestones/$milestoneId/merge_requests');
      var items = <MergeRequest>[];
      for (var item in res.data) {
        items.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, items);
    });
  }

  /// ## List project issue notes
  ///
  /// This method sends a GET request to the GitLab API to list the notes of an issue of a project.
  /// It returns an [PagingResponse<Note>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/issues/{issueIid}/notes [Docs](https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  /// - [data] - [NotesRequest] object
  Future<ApiResult<PagingResponse<Note>>> listProjectIssueNotes(
      int projectId, int issueIid, NotesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listNotes(
        '/api/v4/projects/$projectId/issues/$issueIid/notes', data);
      var items = <Note>[];
      for (var item in res.data) {
        items.add(Note.fromJson(item));
      }
      return constructResponse<Note>(res, items);
    });
  }

  /// ## Add project issue note
  ///
  /// This method sends a POST request to the GitLab API to add a note to an issue of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// POST /api/v4/projects/{projectId}/issues/{issueIid}/notes [Docs](https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  /// - [data] - [NewIssueNoteRequest] object
  Future<ApiResult<void>> addProjectIssueNote(
      int projectId, int issueIid, NewIssueNoteRequest data) async {
    return _guard<void>(() async {
      await apiProvider.addProjectIssueNote(
          '/api/v4/projects/$projectId/issues/$issueIid/notes', data);
    });
  }

  /// ## Update project issue note
  ///
  /// This method sends a PUT request to the GitLab API to update a note of an issue of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// PUT /api/v4/projects/{projectId}/issues/{issueIid}/notes/{noteId} [Docs](https://docs.gitlab.com/ee/api/notes.html#modify-existing-issue-note)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  /// - [noteId] - The ID of the note
  /// - [data] - [UpdateIssueNoteRequest] object
  Future<ApiResult<void>> updateProjectIssueNote(int projectId, int issueIid, int noteId,
      UpdateIssueNoteRequest data) async {
    return _guard<void>(() async {
      await apiProvider.updateProjectIssueNote(
          '/api/v4/projects/$projectId/issues/$issueIid/notes/$noteId', data);
    });
  }

  /// ## Delete project issue note
  ///
  /// This method sends a DELETE request to the GitLab API to delete a note of an issue of a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// DELETE /api/v4/projects/{projectId}/issues/{issueIid}/notes/{noteId} [Docs](https://docs.gitlab.com/ee/api/notes.html#delete-issue-note)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [issueIid] - The IID of the issue
  /// - [noteId] - The ID of the note
  Future<ApiResult<void>> deleteProjectIssueNote(
      int projectId, int issueIid, int noteId) async {
    return _guard<void>(() async {
      await apiProvider.deleteProjectIssueNote(
          '/api/v4/projects/$projectId/issues/$issueIid/notes/$noteId');
    });
  }

  /// ## List group milestones
  ///
  /// This method sends a GET request to the GitLab API to list the milestones of a group.
  /// It returns an [PagingResponse<GroupMilestone>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/groups/{groupId}/milestones [Docs](https://docs.gitlab.com/ee/api/milestones.html#list-group-milestones)
  ///
  /// ### Parameters
  /// - [groupId] - The ID of the group
  /// - [data] - [MilestonesRequest] object
  Future<ApiResult<PagingResponse<GroupMilestone>>> listGroupMilestones(
      int groupId, MilestonesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listMilestones(
        '/api/v4/groups/$groupId/milestones', data);
      var items = <GroupMilestone>[];
      for (var item in res.data) {
        items.add(GroupMilestone.fromJson(item));
      }
      return constructResponse<GroupMilestone>(res, items);
    });
  }

  /// ## List Events
  ///
  /// This method sends a GET request to the GitLab API to list all the events a user has access to.
  /// It returns an [PagingResponse<Event>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/events [Docs](https://docs.gitlab.com/ee/api/events.html#list-currently-authenticated-users-events)
  ///
  /// ### Parameters
  /// - [data] - [EventsRequest] object
  Future<ApiResult<PagingResponse<Event>>> listEvents(EventsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listEvents('/api/v4/events', data);
      var items = <Event>[];
      for (var item in res.data) {
        items.add(Event.fromJson(item));
      }
      return constructResponse<Event>(res, items);
    });
  }

  /// ## List project events
  ///
  /// This method sends a GET request to the GitLab API to list the events of a project.
  /// It returns an [PagingResponse<Event>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/events [Docs](https://docs.gitlab.com/ee/api/events.html#list-a-projects-visible-events)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [EventsRequest] object
  Future<ApiResult<PagingResponse<Event>>> listProjectEvents(
      int projectId, EventsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listEvents(
        '/api/v4/projects/$projectId/events', data);

      var items = <Event>[];
      for (var item in res.data) {
        items.add(Event.fromJson(item));
      }
      return constructResponse<Event>(res, items);
    });
  }

  /// ## List project pipelines
  ///
  /// This method sends a GET request to the GitLab API to list the pipelines of a project.
  /// It returns an [PagingResponse<Pipeline>] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/pipelines [Docs](https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [data] - [ListPipelinesRequest] object
  Future<ApiResult<PagingResponse<Pipeline>>> listPipelines(
      projectId, ListPipelinesRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listPipelines(
        '/api/v4/projects/$projectId/pipelines', data);

      var items = <Pipeline>[];
      for (var item in res.data) {
        items.add(Pipeline.fromJson(item));
      }
      return constructResponse<Pipeline>(res, items);
    });
  }

  Future<ApiResult<Pipeline>> getSinglePipeline(int projectId, int pipelineIid) async {
    return _guard(() async {
      final res = await apiProvider.getSinglePipeline(
        '/api/v4/projects/$projectId/pipelines/$pipelineIid');

      return Pipeline.fromJson(res.data);
    });
  }

  Future<ApiResult<Pipeline>> getLatestPipeline(
      int projectId, LatestPipelineRequest data) async {
    return _guard(() async {
      final res = await apiProvider.getLatestPipeline(
        '/api/v4/projects/$projectId/pipelines/latest', data);

      return Pipeline.fromJson(res.data);
    });
  }

  Future<ApiResult<PagingResponse<Job>>> listProjectJobs(
      int projectId, ListProjectJobsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listJobs(
        '/api/v4/projects/$projectId/pipelines', data);

      var items = <Job>[];
      for (var item in res.data) {
        items.add(Job.fromJson(item));
      }
      return constructResponse<Job>(res, items);
    });
  }

  Future<ApiResult<PagingResponse<Job>>> listPipelineJobs(
      int projectId, int pipelineId, ListPipelineJobsRequest data) async {
    return _guard(() async {
      final res = await apiProvider.listPipelineJobs(
        '/api/v4/projects/$projectId/pipelines/$pipelineId/jobs', data);

      var items = <Job>[];
      for (var item in res.data) {
        items.add(Job.fromJson(item));
      }
      return constructResponse<Job>(res, items);
    });
  }

  Future<ApiResult<Job>> getSingleJob(int projectId, int jobId) async {
    return _guard(() async {
      final res = await apiProvider
        .getSingleJob('/api/v4//projects/$projectId/jobs/$jobId');

      return Job.fromJson(res.data);
    });
  }

  /// ## Construct response
  ///
  /// This method constructs a [PagingResponse] object from the response of a request.
  ///
  /// ### Parameters
  /// - [res] - The response of the request
  /// - [data] - The data of the response
  PagingResponse<T> constructResponse<T>(Response<dynamic> res, List<T> data) {
    return PagingResponse(
        nextPage: int.tryParse(res.headers.value('x-next-page') ?? ""),
        page: int.tryParse(res.headers.value('x-page') ?? ""),
        perPage: int.tryParse(res.headers.value('x-per-page') ?? ""),
        prevPage: int.tryParse(res.headers.value('x-prev-page') ?? ""),
        total: int.tryParse(res.headers.value('x-total') ?? ""),
        totalPages: int.tryParse(res.headers.value('x-total-pages') ?? ""),
        data: data);
  }
}
