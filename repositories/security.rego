package repository

# METADATA
# title: Repository has Advanced Security disabled
# description: >
#   GitHub's Advanced Security features help making the code we
#   build more secure and resilient.
#
#   ### Fix
#
#   Go to your repository settings, navigate to the "Code security and analysis"
#   page and enable every feature listed.
violation_advanced_security_disabled {
	not input.security_and_analysis.advanced_security
	input.security_and_analysis.advanced_security == "disabled"
}

# METADATA
# title: Repository has Secret Scanning disabled
# description: >
#   GitHub's Secret Scanning features prevent contributors from pushing secrets
#   (such as tokens and access keys) to the repository by mistake, and alerts if
#   there are any already commited.
#
#   ### Fix
#
#   Go to your repository settings, navigate to the "Code security and analysis"
#   page and enable every feature listed.
violation_secret_scanning_disabled {
	not input.security_and_analysis.secret_scanning
	input.security_and_analysis.secret_scanning == "disabled"
}

# METADATA
# title: Repository default branch is not protected
# description: >
#   Repository's default branch must be protected to avoid pushing
#   code that might introduce security issues and isn't peer-reviewed.
#
#   ### Fix
#
#   Go to your repository settings, navigate to the "Branches" page, click
#   on the "Add rule" button and add the necessary protections to the default branch.
violation_default_branch_unprotected {
	default_branch_protection.status == 404
}

# METADATA
# title: Repository default branch allows force pushes
violation_default_branch_allow_force_pushes {
	default_branch_protection.body.allow_force_pushes.enabled
}

# METADATA
# title: Pull Requests to the default branch don't require conversation resolution
violation_default_branch_conversation_resolution_not_required {
	not default_branch_protection.body.required_conversation_resolution.enabled
}

# METADATA
# title: Pull Requests to the default branch don't require reviews
violation_default_branch_pull_request_reviews_not_required {
	not default_branch_protection.body.required_pull_request_reviews
}

# METADATA
# title: Pull Requests to the default branch don't require reviews from Code Owners
violation_default_branch_pull_request_code_owner_reviews_not_required {
	not default_branch_protection.body.required_pull_request_reviews.require_code_owner_reviews
}

# METADATA
# title: Repository has open Secret Scanning alerts
violation_secret_scanning_alerts {
	resp := github.request("GET /repos/{owner}/{repo}/secret-scanning/alerts", {
		"owner": input.owner.login,
		"repo": input.name,
		"per_page": 100,
		"state": "open",
	})

	count(resp.body) > 0
}

# METADATA
# title: Repository has open vulnerability alerts
violation_vulnerability_alerts {
	resp := github.graphql(
		`
			query($owner: String!, $name: String!) {
				repository(owner: $owner, name: $name) { 
					vulnerabilityAlerts(first: 100, states: [OPEN]) {
						nodes { createdAt }
					}
				}
			}
		`,
		{
			"owner": input.owner.login,
			"name": input.name,
		},
	)

	alerts := resp.body.data.repository.vulnerabilityAlerts.nodes

	count(alerts) > 0
}
