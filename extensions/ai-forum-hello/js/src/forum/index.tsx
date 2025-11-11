import app from 'flarum/forum/app';
import { extend } from 'flarum/common/extend';
import IndexPage from 'flarum/forum/components/IndexPage';
import HelloButton from './components/HelloButton';

app.initializers.add('ai-forum-hello', () => {
  extend(IndexPage.prototype, 'hero', function (items) {
    items.add('ai-hello', <HelloButton />);
  });
});

