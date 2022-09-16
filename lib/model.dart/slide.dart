class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'images/welcome.png',
    title: 'Welcome to Learneur',
    description: 'We are so Thankful for attempting our App and become a member of , we really appreciate that.',
  ),
  Slide(
    imageUrl: 'images/star.png',
    title: 'Description',
    description: "It's an educational website where students and teachers can learn or upload their courses too",
  ),
  Slide(
    imageUrl: 'images/security.png',
    title: 'Important security tips',
    description: '1- Never disclose your login details to anyone.\n2- Change your password regularly.\n3- If you suspect someone using your account illegally or being toxic or any kind of these things please notify us immediately and we will take legal charges on him/her.',
  ),
];