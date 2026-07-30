#!/usr/bin/env -S awk -f
# awk has no heredoc/triple-quote syntax - adjacent string literals
#  concatenate automatically, so a "\"-continued chain of them (one
#  print statement spanning multiple physical lines) is the closest
#  stand-in for a multi-line string literal. print's own trailing
#  newline (ORS) supplies the final blank line.
BEGIN {
  print "\"The person who moves a mountain begins\n" \
        " by carrying away small stones.\"\n" \
        "\n" \
        "   - Confucious\n" \
        "\n" \
        "\"Yesterday I was clever, so I wanted to change the world.\n" \
        " Today I am wise, so I am I changing myself.\"\n" \
        "\n" \
        "   - Rumi\n" \
        "\n" \
        "\"Action speaks louder than words,\n" \
        "   but not nearly as often.\"\n" \
        "\n" \
        "   - Mark Twain\n" \
        "\n" \
        "\"A designer knows he has achieved perfection\n" \
        " not when there is nothing left to add, but\n" \
        " when there is nothing left to take away.\"\n" \
        "\n" \
        "   - Antoine de Saint-Exupery\n" \
        "\n" \
        "\"There is no greater wealth than wisdom,\n" \
        " no greater poverty than ignorance\"\n" \
        "\n" \
        "   - Ali bin Abu-Talib\n"
}
