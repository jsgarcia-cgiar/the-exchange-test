import app from 'flarum/common/app';

app.initializers.add('cip/ai-forum-hello', () => {
  console.log('[cip/ai-forum-hello] Hello, forum and admin!');
});
