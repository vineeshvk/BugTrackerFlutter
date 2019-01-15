String test = """
query test(\$name:String){
  test(name: \$name)
}
"""
    .replaceAll('\n', ' ');

String viewBugs = """
query ViewBugs(\$userId:String!){
  viewBugs(userId:\$userId){
    id
    title
    description
    status
    assignedTo{
      id
      email
      admin
    }
  }
}
"""
    .replaceAll('\n', ' ');

String allUsers = """
query AllUsers(\$userId:String!){
  allUsers(userId:\$userId){
    id
    email
    admin
  }
}
"""
    .replaceAll('\n', ' ');
