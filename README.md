

# Sync today's WIP completed todos to your Slack channel

:one: [Setup an incoming webhook](https://my.slack.com/services/new/incoming-webhook) and note your `Incoming webhook URL`. You can choose which channel to post to in this step. If you've got multiple project channels you want to post to, you could setup multiple incoming hooks.

:two: [Obtain your `WIP private API key` URL](https://wip.chat/api) from the API page.

:three: Determine your WIP User ID - first complete a todo, then [visit the GraphiQL instance](https://wip.chat/graphiql). Type in the following and you should see your name at the top:
```js
{
  todos {
    user {
      id
      username
    }
  }
}
```

Export all necessary environment variables

```sh
 > export WIP_USER_ID=1096
 > export WIP_PROJECT_NAME=rojak
 > export WIP_API_KEY=xxxxx
 > export SLACK_WEBHOOK_URL=xxxx
 ```
 
Run the main file:

```sh
> ruby main.rb

> #<Net::HTTPOK:0x00007ff91c119d20>
```

Now get back to work.
