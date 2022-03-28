# resource "aws_iam_user" "app_user" {
#     count       = var.iam_user_name != [] ? length(var.iam_user_name) : 0
#     name        = element(var.iam_user_name, count.index)
#     force_destroy = true
#     tags = {
#         Name    = var.env
#     }
# }

# resource "aws_iam_user" "app_user" {
#     for_each    = var.iam_user_name
#     name        = each.key
#     force_destroy = true
#     tags = {
#         Name    = var.env
#     }
# }

# resource "aws_iam_user" "app_user" {
#     count           = length(var.iam_user_name)
#     name            = "user-${count.index+1}"
#     force_destroy = true
#     tags = {
#         Name        = var.env
#     }
# }