function validatePassword() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    // Validar que el correo tenga un formato válido
    if (!email.includes('@') || !email.includes('.')) {
        alert('Por favor, introduce un correo electrónico válido.');
        return false;
    }

    // Validar que la contraseña tenga al menos 8 caracteres
    if (password.length < 8) {
        alert('La contraseña debe tener al menos 8 caracteres.');
        return false;
    }

    // Validar que la contraseña tenga al menos una letra mayúscula y un número
    const regex = /^(?=.*[A-Z])(?=.*\d).+$/;
    if (!regex.test(password)) {
        alert('La contraseña debe incluir al menos una letra mayúscula y un número.');
        return false;
    }

    // Redirigir a la nueva página si todo es correcto
    window.location.href = 'dashboard.html';
    return false; // Prevenir el envío real del formulario
}

// Mostrar/Ocultar contraseña
document.getElementById('toggle-password').addEventListener('click', function () {
    const passwordInput = document.getElementById('password');
    const toggleButton = document.getElementById('toggle-password');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleButton.textContent = 'Ocultar';
    } else {
        passwordInput.type = 'password';
        toggleButton.textContent = 'Mostrar';
    }
});