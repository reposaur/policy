package reposaur.github.pull_request.best_practices

# METADATA
# title: Pull Request title is malformed
# description: >
#   Pull Request titles must follow [Conventional Commits](https://www.conventionalcommits.org) guidelines.
# schemas:
#   - input: schema.github.pull_request
violation_title_malformed {
	not regex.match("(?i)^(\\w+)(\\(.*\\))?(!)?:.*", input.title)
}