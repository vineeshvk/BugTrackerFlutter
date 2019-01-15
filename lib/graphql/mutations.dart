String loginMutation = """
mutation Login(\$email:String!,\$password:String!){
  login(email:\$email,password:\$password){
    admin
    id
  }
}
"""
    .replaceAll('\n', ' ');

String addBug = """
mutation AddBug(\$adminId:String!,\$assignEmail:String!,\$title:String!,\$description:String!){
  addBug
  (adminId:\$adminId,
    assignEmail:\$assignEmail,
    title:\$title,
    description:\$description
  )
}
"""
    .replaceAll('\n', ' ');

String changeStatus = """
mutation ChangeStatus(\$bugId:String!,\$userId:String!,\$status:String!){
	changeStatus(bugId:\$bugId,userId:\$userId,status:\$status)
}
"""
    .replaceAll('\n', ' ');
