import 'dart:async';
import 'package:dio/dio.dart';
import 'package:gitplus_for_gitlab/models/models.dart';
import 'package:gitplus_for_gitlab/models/request/access_token_request_password.dart';

import 'api.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final ApiProvider apiProvider;

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
  Future<AccessTokenResponse?> signInPassword(
      AccessTokenReqestPassword data) async {
    final res = await apiProvider.accessTokenPassword('/oauth/token', data);
    if (res.statusCode == 200) {
      return AccessTokenResponse.fromJson(res.data);
    }
    return null;
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
  Future<AccessTokenResponse?> accessToken(AccessTokenReqest data) async {
    final res = await apiProvider.accessToken('/oauth/token', data);
    if (res.statusCode == 200) {
      return AccessTokenResponse.fromJson(res.data);
    }
    return null;
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
  Future<AccessTokenResponse?> refreshToken(RefreshTokenRequest data) async {
    final res = await apiProvider.refreshToken('/oauth/token', data);
    if (res.statusCode == 200) {
      return AccessTokenResponse.fromJson(res.data);
    }
    return null;
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
  Future<PagingResponse<User>?> listUsers(FindUsersRequest data) async {
    final res = await apiProvider.listUsers('/api/v4/users', data);
    if (res.statusCode == 200) {
      var data = <User>[];
      for (var item in res.data) {
        data.add(User.fromJson(item));
      }
      return constructResponse<User>(res, data);
    }
    return null;
  }

  /// ## Get user
  ///
  /// This method sends a GET request to the GitLab API to get the current user.
  /// It returns an [User] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// `GET /api/v4/user` [Docs](https://docs.gitlab.com/ee/api/users.html#list-current-user)
  Future<User?> getUser() async {
    final res = await apiProvider.getUser('/api/v4/user');
    if (res.statusCode == 200) {
      return User.fromJson(res.data);
    }
    return null;
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
  Future<PagingResponse<Project>?> listProjects(ProjectsRequest data) async {
    final res = await apiProvider.listProjects('/api/v4/projects', data);
    if (res.statusCode == 200) {
      var data = <Project>[];
      for (var item in res.data) {
        data.add(Project.fromJson(item));
      }
      return constructResponse<Project>(res, data);
    }
    return null;
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
  Future<Project?> getProject(int id, ProjectRequest data) async {
    final res = await apiProvider.getProject('/api/v4/projects/$id', data);
    if (res.statusCode == 200) {
      return Project.fromJson(res.data);
    }
    return null;
  }

  /// ## Update project
  ///
  /// This method sends a PUT request to the GitLab API to update a project.
  /// It returns a boolean value indicating whether the request was successful.
  ///
  /// ### Endpoint
  /// `PUT /api/v4/projects/{id}` [Docs](https://docs.gitlab.com/ee/api/projects.html#edit-project)
  Future<bool> updateProject(int projectId, CreateProjectRequest data) async {
    final res =
        await apiProvider.updateProject('/api/v4/projects/$projectId', data);
    return res.statusCode == 200;
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
  Future<bool> createProject(CreateProjectRequest data) async {
    final res = await apiProvider.createProject('/api/v4/projects', data);
    return res.statusCode == 200;
  }

  /// ## Delete project
  ///
  /// This method sends a DELETE request to the GitLab API to delete a project.
  /// It returns an [Project] object if the request is successful, otherwise it returns null.
  /// The project is not actually deleted immediately, but after a short period of time.
  ///
  /// ### Endpoint
  /// `DELETE /api/v4/projects/{id}` [Docs](https://docs.gitlab.com/ee/api/projects.html#delete-a-project)
  Future<Project?> deleteProject(int id) async {
    final res = await apiProvider.deleteProject('/api/v4/projects/$id');
    if (res.statusCode == 200) {
      return Project.fromJson(res.data);
    }
    return null;
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
  Future<void> starProject(int id) async {
    await apiProvider.starUnstarProject('/api/v4/projects/$id/star');
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
  Future<void> unstarProject(int id) async {
    await apiProvider.starUnstarProject('/api/v4/projects/$id/unstar');
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
  Future<PagingResponse<Starrer>?> listProjectStarrers(
      int id, StarrersRequest data) async {
    final res = await apiProvider.listProjectStarrers(
        '/api/v4/projects/$id/starrers', data);
    if (res.statusCode == 200) {
      var data = <Starrer>[];
      for (var item in res.data) {
        data.add(Starrer.fromJson(item));
      }
      return constructResponse<Starrer>(res, data);
    }
    return null;
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
  Future<PagingResponse<Branch>?> listBranches(
      int projectId, BranchesRequest data) async {
    final res = await apiProvider.listBranches(
        '/api/v4/projects/$projectId/repository/branches', data);
    if (res.statusCode == 200) {
      var data = <Branch>[];
      for (var item in res.data) {
        data.add(Branch.fromJson(item));
      }
      return constructResponse<Branch>(res, data);
    }
    return null;
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
  Future<PagingResponse<Tag>?> listTags(int id, TagsRequest data) async {
    final res = await apiProvider.listTags(
        '/api/v4/projects/$id/repository/tags', data);
    if (res.statusCode == 200) {
      var data = <Tag>[];
      for (var item in res.data) {
        data.add(Tag.fromJson(item));
      }
      return constructResponse<Tag>(res, data);
    }
    return null;
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
  Future<PagingResponse<Tree>?> listRepositoryTree(
      int id, TreeRequest data) async {
    final res = await apiProvider.listRepositoryTree(
        '/api/v4/projects/$id/repository/tree', data);
    if (res.statusCode == 200) {
      var data = <Tree>[];
      for (var item in res.data) {
        data.add(Tree.fromJson(item));
      }
      return constructResponse<Tree>(res, data);
    }
    return null;
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
  Future<File?> getFile(
      int projectId, String filePath, FileRequest data) async {
    var encoded = Uri.encodeComponent(filePath);
    final res = await apiProvider.getFile(
        '/api/v4/projects/$projectId/repository/files/$encoded', data);
    if (res.statusCode == 200) {
      return File.fromJson(res.data);
    }
    return null;
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
  Future<PagingResponse<Member>?> listProjectMembers(
      int id, MembersRequest data) async {
    final res =
        await apiProvider.listMembers('/api/v4/projects/$id/members', data);
    if (res.statusCode == 200) {
      var data = <Member>[];
      for (var item in res.data) {
        data.add(Member.fromJson(item));
      }
      return constructResponse<Member>(res, data);
    }
    return null;
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
  Future<bool> addProjectMember(int id, AddMemberRequest data) async {
    final res =
        await apiProvider.addMember('/api/v4/projects/$id/members', data);
    return res.statusCode == 200;
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
  Future<bool> removeProjectMember(int projectId, int memberId) async {
    final res = await apiProvider
        .removeMember('/api/v4/projects/$projectId/members/$memberId');
    return res.statusCode == 200;
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
  Future<PagingResponse<Group>?> listGroups(GroupsRequest data) async {
    final res = await apiProvider.listGroups('/api/v4/groups', data);
    if (res.statusCode == 200) {
      var data = <Group>[];
      for (var item in res.data) {
        data.add(Group.fromJson(item));
      }
      return constructResponse<Group>(res, data);
    }
    return null;
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
  Future<bool> addGroup(AddGroupRequest data) async {
    final res = await apiProvider.addGroup('/api/v4/groups', data);
    return res.statusCode == 200;
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
  Future<PagingResponse<Project>?> listGroupProjects(
      int groupId, GroupProjectsRequest data) async {
    final res = await apiProvider.listGroupProjects(
        '/api/v4/groups/$groupId/projects', data);
    if (res.statusCode == 200) {
      var data = <Project>[];
      for (var item in res.data) {
        data.add(Project.fromJson(item));
      }
      return constructResponse<Project>(res, data);
    }
    return null;
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
  Future<PagingResponse<Member>?> listGroupMembers(
      int id, MembersRequest data) async {
    final res =
        await apiProvider.listMembers('/api/v4/groups/$id/members', data);
    if (res.statusCode == 200) {
      var data = <Member>[];
      for (var item in res.data) {
        data.add(Member.fromJson(item));
      }
      return constructResponse<Member>(res, data);
    }
    return null;
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
  Future<bool> addGroupMember(int id, AddMemberRequest data) async {
    final res = await apiProvider.addMember('/api/v4/groups/$id/members', data);
    return res.statusCode == 200;
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
  Future<bool> removeGroupMember(int groupId, int memberId) async {
    final res = await apiProvider
        .removeGroupMember('/api/v4/groups/$groupId/members/$memberId');
    return res.statusCode == 200;
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
  Future<PagingResponse<Commit>?> listCommits(
      int projectId, CommitsReqest data) async {
    final res = await apiProvider.listCommits(
        '/api/v4/projects/$projectId/repository/commits', data);
    if (res.statusCode == 200) {
      var data = <Commit>[];
      for (var item in res.data) {
        data.add(Commit.fromJson(item));
      }
      return constructResponse<Commit>(res, data);
    }
    return null;
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
  Future<Commit?> getCommit(
      int projectId, String sha, CommitReqest data) async {
    final res = await apiProvider.getCommit(
        '/api/v4/projects/$projectId/repository/commits/$sha', data);
    if (res.statusCode == 200) {
      return Commit.fromJson(res.data);
    }
    return null;
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
  Future<PagingResponse<Diff>?> getDiff(
      int projectId, String sha, DiffRequest data) async {
    final res = await apiProvider.getDiff(
        '/api/v4/projects/$projectId/repository/commits/$sha/diff', data);
    if (res.statusCode == 200) {
      var data = <Diff>[];
      for (var item in res.data) {
        data.add(Diff.fromJson(item));
      }
      return constructResponse<Diff>(res, data);
    }
    return null;
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
  Future<PagingResponse<Issue>?> listIssues(IssuesRequest data) async {
    final res = await apiProvider.listIssues('/api/v4/issues', data);
    if (res.statusCode == 200) {
      var data = <Issue>[];
      for (var item in res.data) {
        data.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, data);
    }
    return null;
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
  Future<PagingResponse<Issue>?> listProjectIssues(
      int projectId, IssuesRequest data) async {
    final res = await apiProvider.listIssues(
        '/api/v4/projects/$projectId/issues', data);
    if (res.statusCode == 200) {
      var data = <Issue>[];
      for (var item in res.data) {
        data.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, data);
    }
    return null;
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
  Future<Issue?> getProjectIssue(int projectId, int iid) async {
    final res =
        await apiProvider.getIssue('/api/v4/projects/$projectId/issues/$iid');
    return Issue.fromJson(res.data);
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
  Future<bool> updateProjectIssue(
      int projectId, int issueIid, UpdateIssueRequest data) async {
    final res = await apiProvider.updateIssue(
        '/api/v4/projects/$projectId/issues/$issueIid', data);
    return res.statusCode == 200;
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
  Future<bool?> addProjectIssue(int projectId, UpdateIssueRequest data) async {
    final res =
        await apiProvider.addIssue('/api/v4/projects/$projectId/issues', data);
    return res.statusCode == 200;
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
  Future<bool> deleteProjectIssue(int projectId, int issueId) async {
    final res = await apiProvider
        .deleteIssue('/api/v4/projects/$projectId/issues/$issueId');
    return res.statusCode == 200;
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
  Future<PagingResponse<MergeRequest>?> listMergeRequests(
      MergeRequestRequest data) async {
    final res =
        await apiProvider.listMergeRequests('/api/v4/merge_requests', data);
    if (res.statusCode == 200) {
      var data = <MergeRequest>[];
      for (var item in res.data) {
        data.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, data);
    }
    return null;
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
  Future<PagingResponse<MergeRequest>?> listProjectMergeRequests(
      int projectId, MergeRequestRequest data) async {
    final res = await apiProvider.listMergeRequests(
        '/api/v4/projects/$projectId/merge_requests', data);
    if (res.statusCode == 200) {
      var data = <MergeRequest>[];
      for (var item in res.data) {
        data.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, data);
    }
    return null;
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
  Future<PagingResponse<MergeRequest>?> listIssueRelatedMergeRequests(
      int projectId, int issueIid) async {
    final res = await apiProvider.listIssueRelatedMergeRequests(
        '/api/v4/projects/$projectId/issues/$issueIid/related_merge_requests');
    if (res.statusCode == 200) {
      var data = <MergeRequest>[];
      for (var item in res.data) {
        data.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, data);
    }
    return null;
  }

  /// ## Get merge request
  ///
  /// This method sends a GET request to the GitLab API to get a merge request.
  /// It returns an [MergeRequest] object if the request is successful, otherwise it returns null.
  ///
  /// ### Endpoint
  /// GET /api/v4/projects/{projectId}/merge_requests/{mrIid} [Docs](https://docs.gitlab.com/ee/api/merge_requests.html#get-single-mr)
  ///
  /// ### Parameters
  /// - [projectId] - The ID of the project
  /// - [mrIid] - The IID of the merge request
  Future<MergeRequest?> getMergeRequest(int projectId, int mrIid) async {
    final res = await apiProvider
        .getMergeRequest('/api/v4/projects/$projectId/merge_requests/$mrIid');
    if (res.statusCode == 200) {
      return MergeRequest.fromJson(res.data);
    }
    return null;
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
  Future<bool> createMergeRequest(int projectId, CreateMRRequest data) async {
    final res = await apiProvider.createMergeRequest(
        '/api/v4/projects/$projectId/merge_requests', data);
    return res.statusCode == 200;
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
  Future<bool> updateMergeRequest(
      int projectId, int mrIid, UpdateMRRequest data) async {
    final res = await apiProvider.updateMergeRequest(
        '/api/v4/projects/$projectId/merge_requests/$mrIid', data);
    return res.statusCode == 200;
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
  Future<bool> deleteMergeRequest(int projectId, int id) async {
    final res = await apiProvider
        .deleteMergeRequest('/api/v4/projects/$projectId/merge_requests/$id');
    return res.statusCode == 200;
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
  Future<PagingResponse<ProjectLabel>?> listProjectLabels(
      int projectId, ProjectLabelsRequest data) async {
    final res = await apiProvider.listProjectLabels(
        '/api/v4/projects/$projectId/labels', data);
    if (res.statusCode == 200) {
      var data = <ProjectLabel>[];
      for (var item in res.data) {
        data.add(ProjectLabel.fromJson(item));
      }
      return constructResponse<ProjectLabel>(res, data);
    }
    return null;
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
  Future<PagingResponse<GroupLabel>?> listGroupLabels(
      int projectId, GroupLabelsRequest data) async {
    final res = await apiProvider.listGroupLabels(
        '/api/v4/projects/$projectId/labels', data); //FIX Is this correct?
    if (res.statusCode == 200) {
      var data = <GroupLabel>[];
      for (var item in res.data) {
        data.add(GroupLabel.fromJson(item));
      }
      return constructResponse<GroupLabel>(res, data);
    }
    return null;
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
  Future<bool> createProjectLabel(
      int projectId, CreateLabelRequest data) async {
    final res = await apiProvider.createLabel(
        '/api/v4/projects/$projectId/labels', data);
    return res.statusCode == 200;
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
  Future<bool> createGroupLabel(int groupId, CreateLabelRequest data) async {
    final res =
        await apiProvider.createLabel('/api/v4/groups/$groupId/labels', data);
    return res.statusCode == 200;
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
  Future<bool> updateProjectLabel(
      int projectId, int labelId, UpdateProjectLabelRequest data) async {
    final res = await apiProvider.updateProjectLabel(
        '/api/v4/projects/$projectId/labels/$labelId', data);
    return res.statusCode == 200;
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
  Future<bool> deleteProjectLabel(int projectId, int labelId) async {
    final res = await apiProvider
        .deleteLabel('/api/v4/projects/$projectId/labels/$labelId');
    return res.statusCode == 200;
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
  Future<PagingResponse<Snippet>?> listSnippets(SnippetsRequest data) async {
    final res = await apiProvider.listSnippets('/api/v4/snippets', data);
    if (res.statusCode == 200) {
      var data = <Snippet>[];
      for (var item in res.data) {
        data.add(Snippet.fromJson(item));
      }
      return constructResponse<Snippet>(res, data);
    }
    return null;
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
  Future<PagingResponse<ProjectSnippet>?> listProjectSnippets(
      int projectId, SnippetsRequest data) async {
    final res = await apiProvider.listSnippets(
        '/api/v4/projects/$projectId/snippets', data);
    if (res.statusCode == 200) {
      var data = <ProjectSnippet>[];
      for (var item in res.data) {
        data.add(ProjectSnippet.fromJson(item));
      }
      return constructResponse<ProjectSnippet>(res, data);
    }
    return null;
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
  Future<ProjectSnippet?> getProjectSnippet(
      int projectId, int snippetId) async {
    final res = await apiProvider
        .getSnippet('/api/v4/projects/$projectId/snippets/$snippetId');
    if (res.statusCode == 200) {
      return ProjectSnippet.fromJson(res.data);
    }
    return null;
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
  Future<String?> getProjectSnippetContent(int projectId, int snippetId) async {
    final res = await apiProvider.getSnippetContent(
        '/api/v4/projects/$projectId/snippets/$snippetId/raw');
    if (res.statusCode == 200) {
      return res.data;
    }
    return null;
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
  Future<bool> addProjectSnippet(
      int projectId, AddUpdateSnippetRequest data) async {
    final res = await apiProvider.addSnippet(
        '/api/v4/projects/$projectId/snippets', data);
    return res.statusCode == 200;
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
  Future<bool> updateProjectSnippet(
      int projectId, int snippetId, AddUpdateSnippetRequest data) async {
    final res = await apiProvider.updateSnippet(
        '/api/v4/projects/$projectId/snippets/$snippetId', data);
    return res.statusCode == 200;
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
  Future<bool> deleteProjectSnippet(int projectId, int snippetId) async {
    final res = await apiProvider
        .deleteSnippet('/api/v4/projects/$projectId/snippets/$snippetId');
    return res.statusCode == 200;
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
  Future<PagingResponse<ProjectMilestone>?> listProjectMilestones(
      int projectId, MilestonesRequest data) async {
    final res = await apiProvider.listMilestones(
        '/api/v4/projects/$projectId/milestones', data);
    if (res.statusCode == 200) {
      var data = <ProjectMilestone>[];
      for (var item in res.data) {
        data.add(ProjectMilestone.fromJson(item));
      }
      return constructResponse<ProjectMilestone>(res, data);
    }
    return null;
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
  Future<ProjectMilestone?> getProjectMilestone(
      int projectId, int milestoneId) async {
    final res = await apiProvider
        .getMilestone('/api/v4/projects/$projectId/milestones/$milestoneId');
    if (res.statusCode == 200) {
      return ProjectMilestone.fromJson(res.data);
    }
    return null;
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
  Future<bool> updateProjectMilestone(
      int projectId, int milestoneId, AddUpdateMilestoneRequest data) async {
    final res = await apiProvider.updateProjectMilestone(
        '/api/v4/projects/$projectId/milestones/$milestoneId', data);
    return res.statusCode == 200;
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
  Future<bool> addProjectMilestone(
      int projectId, AddUpdateMilestoneRequest data) async {
    final res = await apiProvider.addProjectMilestone(
        '/api/v4/projects/$projectId/milestones', data);
    return res.statusCode == 200;
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
  Future<bool> deleteProjectMilestone(int projectId, int milestoneId) async {
    final res = await apiProvider.deleteProjectMilestone(
        '/api/v4/projects/$projectId/milestones/$milestoneId');
    return res.statusCode == 200;
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
  Future<PagingResponse<Issue>?> getMilestoneIssues(
      int projectId, int milestoneId) async {
    final res = await apiProvider.getMilestoneIssues(
        '/api/v4/projects/$projectId/milestones/$milestoneId/issues');
    if (res.statusCode == 200) {
      var data = <Issue>[];
      for (var item in res.data) {
        data.add(Issue.fromJson(item));
      }
      return constructResponse<Issue>(res, data);
    }
    return null;
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
  Future<PagingResponse<MergeRequest>?> getMilestoneMR(
      int projectId, int milestoneId) async {
    final res = await apiProvider.getMilestoneMR(
        '/api/v4/projects/$projectId/milestones/$milestoneId/merge_requests');
    if (res.statusCode == 200) {
      var data = <MergeRequest>[];
      for (var item in res.data) {
        data.add(MergeRequest.fromJson(item));
      }
      return constructResponse<MergeRequest>(res, data);
    }
    return null;
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
  Future<PagingResponse<Note>?> listProjectIssueNotes(
      int projectId, int issueIid, NotesRequest data) async {
    final res = await apiProvider.listNotes(
        '/api/v4/projects/$projectId/issues/$issueIid/notes', data);
    if (res.statusCode == 200) {
      var data = <Note>[];
      for (var item in res.data) {
        data.add(Note.fromJson(item));
      }
      return constructResponse<Note>(res, data);
    }
    return null;
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
  Future<bool> addProjectIssueNote(
      int projectId, int issueIid, NewIssueNoteRequest data) async {
    final res = await apiProvider.addProjectIssueNote(
        '/api/v4/projects/$projectId/issues/$issueIid/notes', data);
    return res.statusCode == 200;
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
  Future<bool> updateProjectIssueNote(int projectId, int issueIid, int noteId,
      UpdateIssueNoteRequest data) async {
    final res = await apiProvider.updateProjectIssueNote(
        '/api/v4/projects/$projectId/issues/$issueIid/notes/$noteId', data);
    return res.statusCode == 200;
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
  Future<bool> deleteProjectIssueNote(
      int projectId, int issueIid, int noteId) async {
    final res = await apiProvider.deleteProjectIssueNote(
        '/api/v4/projects/$projectId/issues/$issueIid/notes/$noteId');
    return res.statusCode == 200;
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
  Future<PagingResponse<GroupMilestone>?> listGroupMilestones(
      int groupId, MilestonesRequest data) async {
    final res = await apiProvider.listMilestones(
        '/api/v4/groups/$groupId/milestones', data);
    if (res.statusCode == 200) {
      var data = <GroupMilestone>[];
      for (var item in res.data) {
        data.add(GroupMilestone.fromJson(item));
      }
      return constructResponse<GroupMilestone>(res, data);
    }
    return null;
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
  Future<PagingResponse<Event>?> listEvents(EventsRequest data) async {
    final res = await apiProvider.listEvents('/api/v4/events', data);
    if (res.statusCode == 200) {
      var data = <Event>[];
      for (var item in res.data) {
        data.add(Event.fromJson(item));
      }
      return constructResponse<Event>(res, data);
    }
    return null;
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
  Future<PagingResponse<Event>?> listProjectEvents(
      int projectId, EventsRequest data) async {
    final res = await apiProvider.listEvents(
        '/api/v4/projects/$projectId/events', data);

    if (res.statusCode == 200) {
      var data = <Event>[];
      for (var item in res.data) {
        data.add(Event.fromJson(item));
      }
      return constructResponse<Event>(res, data);
    }
    return null;
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
  Future<PagingResponse<Pipeline>?> listPipelines(projectId, ListPipelinesRequest data) async {
    final res = await apiProvider.listPipelines('/api/v4/projects/$projectId/pipelines',data);

    if (res.statusCode == 200) {
      var data = <Pipeline>[];
      for (var item in res.data) {
        data.add(Pipeline.fromJson(item));
      }
      return constructResponse<Pipeline>(res, data);
    }
    return null;
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
