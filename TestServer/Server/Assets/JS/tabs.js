// Tabs: turns sections into tabs, as on the usage data page.
//
// The markup: a container with the class "tabs", holding a tab bar (role="tablist", written with
// `hidden`) with one button per tab (role="tab", aria-controls naming its panel), and one section
// per tab (role="tabpanel"), each with a heading of the class "tab-title". Without JavaScript the
// sections are simply shown one below the other, headings and all, and the tab bar stays hidden.
//
// The tab shown first is the one the address names after "#", or else the one the container
// names in data-first-tab, or else the first. Choosing a tab updates the address, so it can be
// bookmarked and "Back" returns to the tab before. Arrow keys move between the tabs.

(function () {
    "use strict";

    Array.prototype.slice.call(document.querySelectorAll(".tabs")).forEach(function (container) {
        var bar = container.querySelector("[role=tablist]");
        if (!bar) { return; }
        var tabs = Array.prototype.slice.call(bar.querySelectorAll("[role=tab]"));
        var panels = tabs.map(function (tab) {
            return document.getElementById(tab.getAttribute("aria-controls"));
        });

        function indexOfPanel(id) {
            for (var i = 0; i < panels.length; i++) {
                if (panels[i] && panels[i].id === id) { return i; }
            }
            return -1;
        }

        function show(index, focus) {
            tabs.forEach(function (tab, i) {
                var on = i === index;
                tab.setAttribute("aria-selected", on ? "true" : "false");
                tab.tabIndex = on ? 0 : -1;
                if (panels[i]) { panels[i].hidden = !on; }
            });
            if (focus) { tabs[index].focus(); }
        }

        function fromAddress() {
            var i = indexOfPanel(window.location.hash.slice(1));
            if (i < 0) { i = indexOfPanel(container.getAttribute("data-first-tab") || ""); }
            return i < 0 ? 0 : i;
        }

        tabs.forEach(function (tab, i) {
            tab.addEventListener("click", function () {
                show(i, false);
                history.replaceState(null, "", "#" + panels[i].id);
            });
            tab.addEventListener("keydown", function (e) {
                var next = null;
                if (e.key === "ArrowRight") { next = (i + 1) % tabs.length; }
                if (e.key === "ArrowLeft") { next = (i - 1 + tabs.length) % tabs.length; }
                if (e.key === "Home") { next = 0; }
                if (e.key === "End") { next = tabs.length - 1; }
                if (next === null) { return; }
                e.preventDefault();
                show(next, true);
                history.replaceState(null, "", "#" + panels[next].id);
            });
        });

        window.addEventListener("hashchange", function () { show(fromAddress(), false); });

        container.classList.add("tabs-on");
        bar.hidden = false;
        show(fromAddress(), false);
    });
})();
