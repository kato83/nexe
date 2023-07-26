import { App, AwsLambdaReceiver } from '@slack/bolt';
import {
  AwsCallback,
  AwsEvent
} from '@slack/bolt/dist/receivers/AwsLambdaReceiver';

if (!process.env.SLACK_SIGNING_SECRET) process.exit(1);

const awsLambdaReceiver = new AwsLambdaReceiver({
  signingSecret: process.env.SLACK_SIGNING_SECRET
});
const app = new App({
  token: process.env.SLACK_BOT_TOKEN,
  receiver: awsLambdaReceiver
});

app.event('app_mention', async ({ event, context: _co, client: _cl, say }) => {
  try {
    const { channel, event_ts, text } = event;
    await say({
      channel,
      thread_ts: event_ts,
      text: text
    });
  } catch (error) {
    console.error(error);
  }
});

module.exports.honi = async (
  event: AwsEvent,
  context: unknown,
  callback: AwsCallback
) => {
  const handler = await awsLambdaReceiver.start();
  return handler(event, context, callback);
};
