// Aquí puedes agregar lógica JS para el dashboard

// Ejemplo: resaltar menú activo al hacer clic
document.querySelectorAll('.sidebar-menu li').forEach(item => {
    item.addEventListener('click', function() {
        document.querySelectorAll('.sidebar-menu li').forEach(li => li.classList.remove('active'));
        this.classList.add('active');
    });
});
