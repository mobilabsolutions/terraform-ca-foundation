resource "azurerm_policy_definition" "require_tag_on_resource_groups" {
  for_each = var.allowed_tags

  name                = "require-tag-${replace(lower(each.key), " ", "-")}"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Require a tag '${each.key}' with specific values"
  description         = "Ensures that the '${each.key}' tag exists with approved values."
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.top_mg_id}"

  metadata = <<METADATA
        {
        "category": "Tags"
        }

    METADATA

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type",
          equals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          not = {
            field = "tags['${each.key}']",
            in    = each.value
          }
        }
      ]
    },
    then = {
      effect = "deny"
    }
  })
}