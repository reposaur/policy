package pull_request

# METADATA
# title: Pull Request title is malformed
# description: >
#   Pull Request titles must follow
#   [Conventional Commits](https://www.conventionalcommits.org) guidelines.
violation_title_malformed {
	not regex.match("(?i)^(\\w+)(\\(.*\\))?:.*", input.title)
}

# METADATA
# title: Pull Request has an empty body
# description: >
#   Pull Requests should have a body to help reviewers understanding
#   the changes proposed and reducing time-to-merge.
violation_title_malformed {
	not regex.match("(?i)^(\\w+)(\\(.*\\))?:.*", input.title)
}
