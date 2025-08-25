document.addEventListener("DOMContentLoaded", function() {
    const hodSection = document.getElementById("department-hod");
    
    function isElementInViewport(el) {
        const rect = el.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }

    function addAnimationClass() {
        if (isElementInViewport(hodSection)) {
            hodSection.classList.add("animate");
            window.removeEventListener("scroll", addAnimationClass);
        }
    }

    window.addEventListener("scroll", addAnimationClass);
    addAnimationClass(); // Check on page load
});
