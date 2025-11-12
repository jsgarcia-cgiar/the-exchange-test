import app from 'flarum/forum/app';
import { extend } from 'flarum/common/extend';
import IndexPage from 'flarum/forum/components/IndexPage';

app.initializers.add('ai-forum-hello', () => {
  extend(IndexPage.prototype, 'contentItems', function (items) {
    const imageUrl = app.forum.attribute('aiForumHello.imageUrl') as string | undefined;
    const imageAlt = (app.forum.attribute('aiForumHello.imageAlt') as string | undefined) || 'Forum banner';

    if (!imageUrl) return;

    items.add(
      'ai-forum-hello.banner',
      <div className="AiForumHelloImage">
        <img src={imageUrl} alt={imageAlt} />
      </div>,
      110
    );
  });
});

