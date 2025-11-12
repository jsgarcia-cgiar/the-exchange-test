import app from 'flarum/admin/app';

app.initializers.add('cip/ai-forum-hello', () => {
  app.extensionData
    .for('cip-ai-forum-hello')
    .registerSetting({
      setting: 'cip-ai-forum-hello.image_url',
      label: app.translator.trans('cip-ai-forum-hello.admin.settings.image_url_label'),
      type: 'text',
      placeholder: 'https://example.com/banner.jpg',
    })
    .registerSetting({
      setting: 'cip-ai-forum-hello.image_alt',
      label: app.translator.trans('cip-ai-forum-hello.admin.settings.image_alt_label'),
      type: 'text',
      placeholder: 'Forum banner',
    });
});
