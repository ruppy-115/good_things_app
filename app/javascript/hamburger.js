const initHamburger = () => {
  const ham = document.querySelector('#js-hamburger');
  const nav = document.querySelector('#js-nav');
  const body = document.body;

  if (ham && nav) {
    const newHam = ham.cloneNode(true);
    ham.parentNode.replaceChild(newHam, ham);

    newHam.addEventListener('click', function () {
      newHam.classList.toggle('active');
      nav.classList.toggle('active');
      
      body.classList.toggle('is-fixed');
    });
  }
};

document.addEventListener('turbo:load', initHamburger);