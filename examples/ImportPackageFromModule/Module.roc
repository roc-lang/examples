module [splitGraphemes]

import unicode.Grapheme

splitGraphemes = \string -> Grapheme.split string

