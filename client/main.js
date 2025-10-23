$js = @'
import { gsap } from "gsap";
import ScrollTrigger from "gsap/ScrollTrigger";
import "./styles/main.css"; // usamos el CSS compilado por build:css

gsap.registerPlugin(ScrollTrigger);

// Ejecutar cuando el DOM esté listo
document.addEventListener("DOMContentLoaded", () => {
  // Set year (si existe)
  const yearEl = document.getElementById("year");
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Simple form handler (si existe)
  const form = document.getElementById("contact-form");
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();
      const btn = form.querySelector("button");
      if (!btn) return;
      btn.disabled = true;
      const prev = btn.textContent;
      btn.textContent = "Enviando...";
      setTimeout(() => {
        btn.textContent = "Enviado";
        form.reset();
        setTimeout(() => {
          btn.disabled = false;
          btn.textContent = prev || "Enviar";
        }, 1200);
      }, 800);
    });
  }

  // Hero/header entrance
  const tl = gsap.timeline({ defaults: { duration: 0.8, ease: "power3.out" } });
  tl.from(".logo img", { opacity: 0, y: -8 })
    .from(".main-nav a", { opacity: 0, y: -6, stagger: 0.08 }, "<")
    .from(".hero-title", { opacity: 0, y: 12 }, "-=0.3")
    .from(".hero-sub", { opacity: 0, y: 12 }, "-=0.65");

  // Parallax hero
  if (document.querySelector("#hero")) {
    gsap.to(".hero-inner", {
      y: -24,
      ease: "none",
      scrollTrigger: {
        trigger: "#hero",
        start: "top top",
        end: "bottom top",
        scrub: 0.6
      }
    });
  }

  // Reveal elements with data-anim
  const animEls = gsap.utils.toArray("[data-anim]");
  animEls.forEach((el, i) => {
    gsap.from(el, {
      opacity: 0,
      y: 18,
      duration: 0.9,
      ease: "power3.out",
      scrollTrigger: {
        trigger: el,
        start: "top 88%",
        toggleActions: "play none none none"
      },
      delay: i * 0.06
    });
  });

  // Micro interactions for .case
  gsap.utils.toArray(".case").forEach((node) => {
    node.addEventListener("mouseenter", () => gsap.to(node, { scale: 1.02, duration: 0.28, ease: "power2.out" }));
    node.addEventListener("mouseleave", () => gsap.to(node, { scale: 1, duration: 0.28, ease: "power2.out" }));
  });
});
'@