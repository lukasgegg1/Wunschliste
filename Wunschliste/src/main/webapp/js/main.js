// Verhindert das Springen zu Ankern beim Neuladen der Seite
window.onload = function() {
    if (window.location.hash) {
        history.replaceState(null, null, window.location.pathname);
    }
};