package repository

# METADATA
# title: Repository description is empty
# description: >
#   It's important that repositories have a description. The
#   description helps other people discovering it and understanding
#   its purpose.
note_empty_description {
	input.description == null
}

# METADATA
# title: Repository doesn't have any topics
# description: >
#   It's important that repositories have meaningful topics. They
#   help other people discovering it and understanding its purpose.
note_no_topics {
	count(input.topics) == 0
}
