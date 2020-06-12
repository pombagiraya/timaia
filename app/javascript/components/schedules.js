const initSchedules = () => {

    document.addEventListener("turbolinks:load", () => {
        const tabElements = documento.querySelectorAll('#nav-tab .tab-link');

        function onTabClick(event) {
            const activeTabs = document.querySelectorAll('.active');

            activeTabs.forEach(function(tab) {
                tab.classList.toggle('active');
            });
        
            event.target.parentElement.classList.add('active');

            event.preventDefault();

            var tabPanel = documento.getElementById(event.href.split("#")[1]);
            tabPanel.classList.toggle('active');
        }

        if(tabElements != null) {
            tabElements.forEach(function(tab) {
                tab.addEventListener('click', (event) => {
                    onTabClick(event);
                });
            });
        }
    });
}