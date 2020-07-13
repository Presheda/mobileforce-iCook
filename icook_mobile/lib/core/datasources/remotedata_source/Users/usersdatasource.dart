abstract class UsersDataSource {
  ///To get all Users{Get}
  Future<void> getAllUsers();

  ///To get a particular User{Get}
  Future<void> getAUser();

  ///To follow a User{Put}
  Future<dynamic> followUser(String id);

  ///To get all Followers{Get}
  Future<void> getFollowers();

  ///To get all users following user{Get}
  Future<void> getFollowings();

  ///To unfollow a User{Put}
  Future<dynamic> unfollowUser(String id);
}
