package organization

# METADATA
# title: Organization has 2FA requirement disabled
# description: Organization doesn't require members to have 2FA enabled
warn_two_factor_requirement_disabled {
	input.two_factor_requirement_enabled == false
}