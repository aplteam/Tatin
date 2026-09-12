// The list of packages (/v1/packages): filter, sort switch and "Include tags in the filter".
//
// Without JavaScript the page shows every package grouped by its group, which is also the
// default view; the tools stay hidden then because they could not do anything.
//
// The rows carry what the tools need as data attributes, written by
// PrepareHtmlPageForPackageList: data-name (the full package name), data-desc, data-tags
// (separated by blanks) and data-majors.
//
// A link like /v1/packages?tag=files - which is what the tags in the list are - shows only the
// packages carrying exactly that tag, together with a button that shows all packages again.

(function () {
    "use strict";

    var list = document.getElementById("pkg-list");
    if (!list) { return; }

    var tools = document.getElementById("pkg-tools");
    var input = document.getElementById("pkg-filter");
    var includeTags = document.getElementById("pkg-include-tags");
    var count = document.getElementById("pkg-count");
    var flat = document.getElementById("pkg-flat");
    var groups = Array.prototype.slice.call(list.querySelectorAll(".pkg-group"));
    var rows = Array.prototype.slice.call(list.querySelectorAll(".pkg-row"));
    var buttons = Array.prototype.slice.call(document.querySelectorAll("#pkg-sort button"));
    var total = rows.length;
    var mode = "group";
    var tagFilter = null;

    rows.forEach(function (row, i) {
        row.pkgHome = row.parentNode;
        row.pkgIndex = i;
        row.pkgName = row.getAttribute("data-name") || "";
        row.pkgMajors = Number(row.getAttribute("data-majors")) || 0;
        row.pkgText = (row.pkgName + " " + (row.getAttribute("data-desc") || "")).toLowerCase();
        row.pkgTags = (row.getAttribute("data-tags") || "").toLowerCase();
        row.pkgTagList = row.pkgTags ? row.pkgTags.split(/\s+/) : [];
    });

    // Every word typed must occur somewhere: in the name (and thereby the group), the
    // description or, when asked for, the tags. A tag link on top of that demands the tag itself.
    function applyFilter() {
        var words = input.value.toLowerCase().split(/\s+/).filter(Boolean);
        var withTags = includeTags.checked;
        var shown = 0;
        rows.forEach(function (row) {
            var text = withTags ? row.pkgText + " " + row.pkgTags : row.pkgText;
            var match = words.every(function (word) { return text.indexOf(word) >= 0; }) &&
                (tagFilter === null || row.pkgTagList.indexOf(tagFilter) >= 0);
            row.hidden = !match;
            if (match) { shown++; }
        });
        groups.forEach(function (group) {
            group.hidden = mode !== "group" || !group.querySelector(".pkg-row:not([hidden])");
        });
        count.textContent = shown + " of " + total;
    }

    function byName(a, b) {
        return a.pkgName.localeCompare(b.pkgName, "en", { sensitivity: "base" });
    }

    function byMajors(a, b) {
        return (b.pkgMajors - a.pkgMajors) || byName(a, b);
    }

    // "group" puts every row back into its group, in the order the server wrote them;
    // "name" and "majors" show one flat list with the full package names.
    function sortBy(newMode) {
        mode = newMode;
        buttons.forEach(function (button) {
            button.setAttribute("aria-pressed", String(button.getAttribute("data-sort") === mode));
        });
        list.setAttribute("data-view", mode);
        if (mode === "group") {
            rows.slice().sort(function (a, b) { return a.pkgIndex - b.pkgIndex; })
                .forEach(function (row) { row.pkgHome.appendChild(row); });
            flat.hidden = true;
        } else {
            rows.slice().sort(mode === "name" ? byName : byMajors)
                .forEach(function (row) { flat.appendChild(row); });
            flat.hidden = false;
        }
        applyFilter();
    }

    // The note that a tag link is in force, with the button that lifts it
    function showTagNote(tag) {
        var note = document.createElement("p");
        var label = document.createElement("span");
        var name = document.createElement("b");
        var showAll = document.createElement("button");
        note.className = "tag-filter";
        label.appendChild(document.createTextNode("Only packages tagged "));
        name.textContent = "#" + tag;
        label.appendChild(name);
        showAll.type = "button";
        showAll.textContent = "Show all packages";
        showAll.addEventListener("click", function () {
            tagFilter = null;
            note.hidden = true;
            try { window.history.replaceState(null, "", window.location.pathname); } catch (ignore) { }
            applyFilter();
            input.focus();
        });
        note.appendChild(label);
        note.appendChild(showAll);
        tools.appendChild(note);
    }

    buttons.forEach(function (button) {
        button.addEventListener("click", function () { sortBy(button.getAttribute("data-sort")); });
    });

    input.addEventListener("input", applyFilter);
    includeTags.addEventListener("change", applyFilter);

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

    var tagParameter = new URLSearchParams(window.location.search).get("tag");
    if (tagParameter) {
        tagFilter = tagParameter.toLowerCase();
        showTagNote(tagParameter);
    }

    tools.hidden = false;
    list.setAttribute("data-view", mode);
    applyFilter();
})();
