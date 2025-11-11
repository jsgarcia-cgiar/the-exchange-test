import app from 'flarum/admin/app';

app.initializers.add('cip/ai-forum-hello', () => {
  console.log('[cip/ai-forum-hello] Hello, admin!');
});
