import app from 'flarum/forum/app';
import Button from 'flarum/common/components/Button';
import Component from 'flarum/common/Component';

export default class HelloButton extends Component {
  view() {
    return (
      <Button className="Button" onclick={this.onClick.bind(this)}>
        {app.translator.trans('cip-ai-forum-hello.forum.say_hello')}
      </Button>
    );
  }

  async onClick() {
    try {
      const res:any = await app.request({
        method: 'POST',
        url: app.forum.attribute('apiUrl') + '/ai-hello/click',
      });
      alert(res.message + '\n' + res.time);
    } catch (e) {
      console.error(e);
      alert('Request failed');
    }
  }
}

