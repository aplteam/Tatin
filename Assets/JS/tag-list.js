// The index of tags (/v1/tags): the filter.
//
// Without JavaScript the page shows every tag, under its first letter; the filter stays hidden
// then because it could not do anything.
//
// Every word typed must occur in a tag for that tag to stay; a letter without any tag left is
// hidden as well.

(function () {
    "use strict";

    var index = document.getElementById("tag-index");
    if (!index) { return; }

    var tools = document.getElementById("tag-tools");
    var input = document.getElementById("tag-filter");
    var none = document.getElementById("tag-none");
    var letters = Array.prototype.slice.call(index.querySelectorAll(".tag-letter"));
    var items = Array.prototype.slice.call(index.querySelectorAll("li"));

    items.forEach(function (item) {
        item.tagText = item.textContent.toLowerCase();
    });

    function applyFilter() {
        var words = input.value.toLowerCase().split(/\s+/).filter(Boolean);
        var shown = 0;
        items.forEach(function (item) {
            var match = words.every(function (word) { return item.tagText.indexOf(word) >= 0; });
            item.hidden = !match;
            if (match) { shown++; }
        });
        letters.forEach(function (letter) {
            letter.hidden = !letter.querySelector("li:not([hidden])");
        });
        none.hidden = shown > 0;
    }

    input.addEventListener("input", applyFilter);

    input.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            e.preventDefault();
            input.value = "";
            applyFilter();
        }
    });

    // "/" from anywhere on the page jumps into the filter, unless one is typing somewhere
    document.addEventListener("keydown", function (e) {
        if (e.key !== "/" || e.ctrlKey || e.altKey || e.metaKey) { return; }
        var el = e.target, tag = (el.tagName || "").toLowerCase();
        var typing = tag === "textarea" || tag === "select" || el.isContentEditable ||
            (tag === "input" && !/^(checkbox|radio|button|submit|reset|file|range|color)$/.test(el.type));
        if (typing) { return; }
        e.preventDefault();
        input.focus();
    });

    tools.hidden = false;
    applyFilter();
})();
