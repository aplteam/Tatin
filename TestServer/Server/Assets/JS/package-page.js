// The package page (/v1/packages/versions/...): the list of releases shows only the newest ones
// at first, with a button that shows the rest in place.
//
// Without JavaScript every release is simply listed. The copy button next to the install
// command is not made here but by GetJavaScriptForCopyButton.
//
// The list of releases comes from GetReleaseList.

(function () {
    "use strict";

    var shownAtFirst = 12;
    var list = document.getElementById("release-list");
    if (!list) { return; }

    var items = Array.prototype.slice.call(list.children);
    if (items.length <= shownAtFirst) { return; }

    var button = document.createElement("button");
    button.type = "button";
    button.className = "show-all";
    button.textContent = "Show all " + items.length + " releases";
    button.insertAdjacentHTML("beforeend",
        '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" ' +
        'stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M6 9l6 6 6-6"></path></svg>');

    items.slice(shownAtFirst).forEach(function (item) { item.hidden = true; });

    // Once everything is shown the button has nothing left to do. The focus moves to the first
    // release that has just appeared, so that keyboard users carry on where the list grew.
    button.addEventListener("click", function () {
        items.forEach(function (item) { item.hidden = false; });
        button.parentNode.removeChild(button);
        var link = items[shownAtFirst].querySelector("a");
        if (link) { link.focus(); }
    });

    list.parentNode.insertBefore(button, list.nextSibling);
})();
