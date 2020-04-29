import uuid

import requests
from telegram.ext import (Updater, CommandHandler, MessageHandler, Filters, ConversationHandler, PicklePersistence)


class PhotoBot:
    def __init__(self, working_dir, pin, telegram_token):
        self.set_pin_workflow = range(1)
        self.working_dir = working_dir
        self.url = "http://localhost:5600"
        self.pin = int(pin)
        self.telegram_token = str(telegram_token)
        self.main()

    def start(self, update, context):
        current_pin = context.user_data.get('pin') or None

        if (current_pin is None) or (int(current_pin) != self.pin):
            update.message.reply_text(
                'Hallo! \nIch bin dein Bilderrahmen 😁 🏞 🎉 \n\n'
                'Bitte schicke mir die aufgedruckte PIN.')
            return self.set_pin_workflow
        else:
            update.message.reply_text(
                'Deine PIN wurde bereits erfolgreich gesetzt 😄. Du kannst nun Bilder an mich senden 🙏.')
            return ConversationHandler.END

    def set_pin(self, update, context):
        context.user_data['pin'] = update.message.text
        return ConversationHandler.END

    def photo_handler(self, update, context):
        current_pin = context.user_data.get('pin') or None

        if (current_pin is None) or (int(current_pin) != self.pin):
            update.message.reply_text(
                'Du hast keine PIN gesetzt oder deine PIN ist falsch 😱.\n'
                'Bitte nutze den /start command 🧐.')
        else:
            filename = str(uuid.uuid4())
            try:
                photo_file = update.message.photo[-1].get_file()
            except:
                photo_file = update.message.document[-1].get_file()
            photo_file.download('%s/../images/%s.jpg' % (self.working_dir, filename))
            requests.get(self.url + '/next/%s.jpg' % filename).json()
            update.message.reply_text('Danke für das Photo 🤩!\n'
                                      'Ich zeige es dir gleich an.')

    def delete_photo(self, update, context):
        r = requests.delete(self.url + '/delete').json()
        if int(r['status']) == 200:
            update.message.reply_text('Photo erfolgreich gelöscht ✅!\n'
                                      'Ich zeige es dir nicht mehr an.')
        else:
            update.message.reply_text('Fehler ❌!\n')

    def next_photo(self, update, context):
        r = requests.get(self.url + '/next').json()
        if int(r['status']) == 200:
            update.message.reply_text('Ok, ich zeige dir das nächste Photo an 🏞.')
        else:
            update.message.reply_text('Fehler ❌!\n')

    def error(self, update, context):
        print('Update "%s" caused error "%s"', update, context.error)

    def cancel(self):
        return ConversationHandler.END

    def main(self):
        updater = Updater(
            self.telegram_token,
            persistence=PicklePersistence(filename='%s/../data/conversationbot' % self.working_dir),
            use_context=True
        )

        dp = updater.dispatcher

        start_conversation_handler = ConversationHandler(
            entry_points=[CommandHandler('start', self.start)],
            states={
                self.set_pin_workflow: [MessageHandler(Filters.text, self.set_pin)]
            },
            fallbacks=[CommandHandler('cancel', self.cancel)]
        )

        dp.add_handler(start_conversation_handler)

        dp.add_handler(CommandHandler('delete', self.delete_photo))

        dp.add_handler(CommandHandler('next', self.next_photo))

        dp.add_handler(MessageHandler(Filters.photo, self.photo_handler))

        dp.add_handler(MessageHandler(Filters.document.category('image/'), self.photo_handler))

        dp.add_error_handler(self.error)

        updater.start_polling()

        updater.idle()
