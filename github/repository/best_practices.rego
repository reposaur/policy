package reposaur.github.repository.best_practices

# METADATA
# title: Repository description is empty
# description: >
#   It's important that repositories have a description. The
#   description helps other people discovering it and understanding
#   its purpose.
# schemas:
#   - input: schema.github.repository
note_empty_description {
	not input.description
}

# METADATA
# title: Repository doesn't have any topics
# description: >
#   It's important that repositories have meaningful topics. They
#   help other people discovering it and understanding its purpose.
# schemas:
#   - input: schema.github.repository
violation_no_topics {
	count(input.topics) == 0
}