extends Node

# For one to many signals
# See top comment here: https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html

'''
	Signal Bus (for routing many signals).
'''

# UI Signals
signal update_status_text(new_text)

# Event for when the character dies.
signal on_character_death()

# Event for when an enemy dies.
signal on_enemy_death()
