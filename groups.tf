data "azuread_user" "simonthomas" {
  user_principal_name = "simon.thomas@civica.co.uk"
}

data "azuread_user" "warrenjones" {
  user_principal_name = "warren.jones@civica.co.uk"
}

resource "azuread_group" "idiom" {
  name = "UK-CG-MAS-IDIOM"
  owners = [
      "7956891c-a114-4d6a-9565-ae33ad53aacf",
      "e41bbfca-379a-4159-bd56-4906ce5bf237",
  ]
}