/* =========================================
   TEM // SYSTEM.ROOT — Landing Interactions
   ========================================= */
document.addEventListener('DOMContentLoaded', function () {

  /* ============================
     HERO REEL — frame cycler
     ============================ */
  const frames = document.querySelectorAll('.reel-frame');
  const chapterNum = document.getElementById('chapterNum');
  const reelProgress = document.getElementById('reelProgress');
  if (frames.length && chapterNum && reelProgress) {
    let currentFrame = 0;
    const frameDuration = 5000;
    let frameTimer = 0;
    let lastTime = performance.now();

    function showFrame(idx) {
      frames.forEach((f, i) => f.classList.toggle('active', i === idx));
      chapterNum.textContent = String(idx + 1).padStart(2, '0');
    }

    function tickReel(now) {
      const dt = now - lastTime;
      lastTime = now;
      frameTimer += dt;
      const pct = Math.min((frameTimer / frameDuration) * 100, 100);
      reelProgress.style.width = pct + '%';

      if (frameTimer >= frameDuration) {
        frameTimer = 0;
        currentFrame = (currentFrame + 1) % frames.length;
        showFrame(currentFrame);
      }
      requestAnimationFrame(tickReel);
    }
    requestAnimationFrame(tickReel);
  }

  /* ============================
     REVEAL ON SCROLL
     ============================ */
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('in-view');
        revealObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -40px 0px' });

  document.querySelectorAll('.reveal, .reveal-stagger').forEach(el => {
    revealObserver.observe(el);
  });

  /* ============================
     NUMBER COUNTERS
     ============================ */
  const counters = document.querySelectorAll('.number-display');
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const raw = el.dataset.count;
        const suffix = el.dataset.suffix || '';
        const numeric = parseFloat(raw);
        if (isNaN(numeric)) { counterObserver.unobserve(el); return; }

        const duration = 1800;
        const start = performance.now();

        function step(now) {
          const elapsed = now - start;
          const progress = Math.min(elapsed / duration, 1);
          const eased = 1 - Math.pow(1 - progress, 3);
          const value = Math.floor(eased * numeric);
          if (progress < 1) {
            el.textContent = value + suffix;
            requestAnimationFrame(step);
          } else {
            el.textContent = raw + suffix;
          }
        }
        requestAnimationFrame(step);
        counterObserver.unobserve(el);
      }
    });
  }, { threshold: 0.4 });

  counters.forEach(c => counterObserver.observe(c));

  /* ============================
     STICKY CTA BAR
     ============================ */
  const stickyCta = document.getElementById('stickyCta');
  const heroSection = document.getElementById('inicio');
  const bookingAnchor = document.getElementById('comenzar');

  if (stickyCta && heroSection) {
    let heroPassed = false;
    let atBooking = false;

    const stickyObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.target === heroSection) heroPassed = !entry.isIntersecting;
        if (entry.target === bookingAnchor) atBooking = entry.isIntersecting;
        updateSticky();
      });
    }, { threshold: 0 });

    stickyObserver.observe(heroSection);
    if (bookingAnchor) stickyObserver.observe(bookingAnchor);

    function updateSticky() {
      stickyCta.classList.toggle('visible', heroPassed && !atBooking);
    }
  }

  /* ============================
     GRAIN PARALLAX
     ============================ */
  const grain = document.getElementById('grain');
  if (grain) {
    let targetY = 0, currentY = 0;
    window.addEventListener('scroll', () => {
      targetY = window.scrollY * 0.12;
    }, { passive: true });

    function animateGrain() {
      currentY += (targetY - currentY) * 0.06;
      grain.style.transform = 'translateY(' + currentY + 'px)';
      requestAnimationFrame(animateGrain);
    }
    animateGrain();
  }

  /* ============================
     HERO REEL PARALLAX
     ============================ */
  const reelContainer = document.getElementById('reelContainer');
  if (reelContainer) {
    window.addEventListener('scroll', () => {
      const scrolled = window.scrollY;
      if (scrolled < window.innerHeight) {
        reelContainer.style.transform = 'translateY(' + (scrolled * 0.25) + 'px)';
      }
    }, { passive: true });
  }

  /* ============================
     STORIES CAROUSEL — drag/snap
     ============================ */
  class StoriesCarousel {
    constructor(track, opts = {}) {
      this.track = track;
      if (!track) return;
      this.cards = Array.from(track.children);
      if (this.cards.length === 0) return;
      this.currentIndex = 0;
      this.isDown = false;
      this.startX = 0; this.startOffset = 0; this.currentX = 0;
      this.velocity = 0; this.lastX = 0; this.lastTime = 0;
      this.cardWidth = 0; this.maxScroll = 0;
      this.autoAdvance = opts.autoAdvance !== false;
      this.autoInterval = opts.interval || 4500;
      this.autoTimer = null;
      this.pauseAuto = false;
      this.init();
    }

    init() {
      this.calculateDimensions();
      this.bindEvents();
      this.buildDots();
      this.startAuto();
      window.addEventListener('resize', () => {
        this.calculateDimensions();
        this.clamp();
        this.applyTransform(0);
      });
    }

    calculateDimensions() {
      if (this.cards.length === 0) return;
      const trackStyle = window.getComputedStyle(this.track);
      const gap = parseFloat(trackStyle.gap) || 24;
      const paddingLeft = parseFloat(trackStyle.paddingLeft) || 0;
      this.cardWidth = this.cards[0].offsetWidth + gap;
      const containerWidth = this.track.parentElement.offsetWidth;
      const totalWidth = (this.cards.length * this.cardWidth) - gap + paddingLeft * 2;
      this.maxScroll = Math.max(0, totalWidth - containerWidth);
    }

    bindEvents() {
      const down = (e) => this.handleDown(e);
      const move = (e) => this.handleMove(e);
      const up = () => this.handleUp();

      this.track.addEventListener('mousedown', down);
      this.track.addEventListener('touchstart', down, { passive: true });
      window.addEventListener('mousemove', move);
      window.addEventListener('touchmove', move, { passive: false });
      window.addEventListener('mouseup', up);
      window.addEventListener('touchend', up);
      window.addEventListener('touchcancel', up);

      this.track.addEventListener('mouseenter', () => this.pauseAuto = true);
      this.track.addEventListener('mouseleave', () => this.pauseAuto = false);

      const prev = document.getElementById('storyPrev');
      const next = document.getElementById('storyNext');
      if (prev) prev.addEventListener('click', () => this.goTo(this.currentIndex - 1));
      if (next) next.addEventListener('click', () => this.goTo(this.currentIndex + 1));
    }

    handleDown(e) {
      this.isDown = true;
      this.track.classList.add('dragging');
      const x = e.type.includes('touch') ? e.touches[0].pageX : e.pageX;
      this.startX = x; this.startOffset = this.currentX;
      this.lastX = x; this.lastTime = Date.now();
      this.velocity = 0; this.stopAuto();
    }

    handleMove(e) {
      if (!this.isDown) return;
      if (e.cancelable) e.preventDefault();
      const x = e.type.includes('touch') ? e.touches[0].pageX : e.pageX;
      const delta = x - this.startX;
      let newX = this.startOffset + delta;
      if (newX > 0) newX = newX * 0.3;
      else if (newX < -this.maxScroll) { const over = newX + this.maxScroll; newX = -this.maxScroll + over * 0.3; }
      const now = Date.now();
      const dt = now - this.lastTime;
      if (dt > 0) this.velocity = (x - this.lastX) / dt;
      this.lastX = x; this.lastTime = now;
      this.currentX = newX;
      this.applyTransform(0);
    }

    handleUp() {
      if (!this.isDown) return;
      this.isDown = false;
      this.track.classList.remove('dragging');
      let target = this.currentX + this.velocity * 350;
      const snapIndex = Math.round(-target / this.cardWidth);
      const clampedIndex = Math.max(0, Math.min(this.cards.length - 1, snapIndex));
      let snappedX = -clampedIndex * this.cardWidth;
      if (snappedX > 0) snappedX = 0;
      if (snappedX < -this.maxScroll) snappedX = -this.maxScroll;
      this.currentX = snappedX; this.currentIndex = clampedIndex;
      this.applyTransform(600); this.updateDots();
      setTimeout(() => this.startAuto(), 1800);
    }

    goTo(idx) {
      this.currentIndex = Math.max(0, Math.min(this.cards.length - 1, idx));
      let target = -this.currentIndex * this.cardWidth;
      if (target > 0) target = 0;
      if (target < -this.maxScroll) target = -this.maxScroll;
      this.currentX = target; this.applyTransform(600); this.updateDots();
      this.stopAuto(); setTimeout(() => this.startAuto(), 2500);
    }

    clamp() {
      if (this.currentX > 0) this.currentX = 0;
      if (this.currentX < -this.maxScroll) this.currentX = -this.maxScroll;
    }

    applyTransform(duration) {
      this.track.style.transition = duration > 0 ? 'transform ' + duration + 'ms cubic-bezier(0.16, 1, 0.3, 1)' : 'none';
      this.track.style.transform = 'translateX(' + this.currentX + 'px)';
    }

    buildDots() {
      const container = document.getElementById('storyDots');
      if (!container) return;
      container.innerHTML = '';
      this.cards.forEach((_, i) => {
        const dot = document.createElement('button');
        dot.className = 'carousel-dot';
        if (i === 0) dot.classList.add('active');
        dot.addEventListener('click', () => this.goTo(i));
        container.appendChild(dot);
      });
    }

    updateDots() {
      const dots = document.querySelectorAll('#storyDots .carousel-dot');
      dots.forEach((dot, i) => dot.classList.toggle('active', i === this.currentIndex));
    }

    startAuto() { if (!this.autoAdvance) return; this.stopAuto(); this.autoTimer = setInterval(() => { if (this.pauseAuto || this.isDown) return; this.goTo((this.currentIndex + 1) % this.cards.length); }, this.autoInterval); }
    stopAuto() { if (this.autoTimer) { clearInterval(this.autoTimer); this.autoTimer = null; } }
  }

  new StoriesCarousel(document.getElementById('storyTrack'), { interval: 4500 });

});
