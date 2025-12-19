from __future__ import annotations

import re
import unicodedata

from anki.hooks import wrap
from anki.utils import strip_html
from aqt import gui_hooks, mw
from aqt.reviewer import Reviewer

_LINEBREAKS_RE = re.compile(r"(?is)(\n|<br\s*/?>|</?div>)+")


def _strip_expected(text: str) -> str:
    try:
        text = mw.col.media.strip_av_tags(text)
    except Exception:
        pass
    text = _LINEBREAKS_RE.sub(" ", text)
    return strip_html(text).strip()


def _strip_accents(text: str) -> str:
    return "".join(
        char
        for char in unicodedata.normalize("NFD", text)
        if not unicodedata.combining(char)
    )


def _is_accent_only_mismatch(expected: str, provided: str) -> bool:
    if not expected or not provided:
        return False
    if expected == provided:
        return False
    return _strip_accents(expected) == _strip_accents(provided)


def _mark_fuzzy(output: str) -> str:
    output = output.replace("class=typeBad", "class=typeFuzzy")
    output = output.replace("class=typeMissed", "class=typeFuzzy")
    return output


def _type_ans_answer_filter(self: Reviewer, buf: str, _old) -> str:
    output = _old(self, buf)
    if not self.typeCorrect:
        return output

    match = re.search(self.typeAnsPat, buf)
    type_pattern = match.group(1) if match else ""
    if type_pattern.startswith("nc:"):
        return output

    expected = _strip_expected(self.typeCorrect)
    provided = (self.typedAnswer or "").strip()
    if _is_accent_only_mismatch(expected, provided):
        return _mark_fuzzy(output)
    return output


def _inject_fuzzy_style(html: str, card, context: str) -> str:
    if context != "reviewAnswer":
        return html
    if ".typeFuzzy" in html:
        return html
    return (
        html
        + """
<style>
.typeFuzzy {
    background: #fdba74;
    color: black;
}
</style>
"""
    )


Reviewer.typeAnsAnswerFilter = wrap(
    Reviewer.typeAnsAnswerFilter, _type_ans_answer_filter, "around"
)
gui_hooks.card_will_show.append(_inject_fuzzy_style)
