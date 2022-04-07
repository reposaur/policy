package pull_request

warn_assignees[msg] {
	count(input.pull_request.assignees) == 0
	msg := "Pull Requests should have at least one assignee, got 0"
}

warn_body[msg] {
	input.pull_request.body == null
	msg := "Pull Requests should have a body explaining what they're addressing"
}

violation_title[msg] {
	not regex.match("(?i)^(\\w+)(\\(.*\\))?:.*", input.pull_request.title)
	msg := sprintf("Pull Requests titles must follow the Conventional Commits guidelines, got: %s", [input.pull_request.title])
}

violation_reviewers[msg] {
	count(input.pull_request.requested_reviewers) == 0
	msg := "Pull Requests must have at least one reviewer, got 0"
}

violation_security_alerts[msg] {
	alerts := github.request("GET /repos/{owner}/{repo}/code-scanning/alerts", {
		"owner": input.repository.owner.login,
		"repo": input.repository.name,
		"per_page": 100,
		"state": "open",
		"ref": input.pull_request.head.ref,
	})

	count(alerts) > 0

	msg := sprintf("Repositories must not have any open code scanning alerts, got %d", [count(alerts)])
}

violation_security_alerts[msg] {
	alerts := github.request("GET /repos/{owner}/{repo}/secret-scanning/alerts", {
		"owner": input.repository.owner.login,
		"repo": input.repository.name,
		"per_page": 100,
		"state": "open",
	})

	count(alerts) > 0

	msg := sprintf("Repositories must not have any open secret scanning alerts, got %d", [count(alerts)])
}

violation_security_alerts[msg] {
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
			"owner": input.repository.owner.login,
			"name": input.repository.name,
		},
	)

	alerts := resp.data.repository.vulnerabilityAlerts.nodes

	count(alerts) > 0

	msg := sprintf("Repositories must not have any open vulnerability alerts, got %d", [count(alerts)])
}
