tree --gitignore
.
├── public
│   ├── file.svg
│   ├── globe.svg
│   ├── next.svg
│   ├── vercel.svg
│   └── window.svg
├── src
│   ├── app
│   │   ├── favicon.ico
│   │   ├── globals.css
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   ├── about
│   │   │   └── page.tsx
│   │   ├── products
│   │   │   ├── page.tsx
│   │   │   └── [productId]
│   │   │       ├── page.tsx
│   │   │       ├── modules
│   │   │       │   └── [moduleId]
│   │   │       │       └── page.tsx
│   │   ├── blog
│   │   │   ├── page.tsx
│   │   │   └── [postId]
│   │   │       └── page.tsx
│   │   ├── admin
│   │   │   ├── layout.tsx
│   │   │   ├── page.tsx
│   │   │   ├── products
│   │   │   │   └── page.tsx
│   │   │   ├── modules
│   │   │   │   └── page.tsx
│   │   │   ├── users
│   │   │   │   └── page.tsx
│   │   │   ├── content
│   │   │   │   └── page.tsx
│   │   │   └── oauth
│   │   │       └── page.tsx
│   │   ├── auth
│   │   │   ├── login.tsx
│   │   │   ├── register.tsx
│   │   │   └── oauth.tsx
│   ├── components
│   │   ├── ThreeScene.tsx
│   │   ├── AnimatedButton.tsx
│   │   ├── GradientBackground.tsx
│   │   ├── PageTransition.tsx
│   │   ├── Footer.tsx
│   │   ├── Navbar.tsx
│   │   └── ProductCard.tsx
│   ├── hooks
│   │   ├── useThree.ts
│   │   ├── useAuth.ts
│   │   └── usePermissions.ts
│   ├── lib
│   │   ├── appwrite.ts
│   │   └── theme.ts
│   └── types
│       ├── product.ts
│       ├── module.ts
│       ├── user.ts
│       ├── content.ts
│       └── oauth.ts
