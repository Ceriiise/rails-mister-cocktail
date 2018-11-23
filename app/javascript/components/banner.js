import Typed from 'typed.js';

const loadDynamicBannerText = () => {
  new Typed('#banner-typed-text', {
    strings: ["Awesome beverages for developers nightlife"],
    typeSpeed: 50,
    loop: true
  });
};

export { loadDynamicBannerText };
