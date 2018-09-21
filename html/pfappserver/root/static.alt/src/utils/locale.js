import Vue from 'vue'
import VueI18n from 'vue-i18n'
import Formatter from './formatter'

Vue.use(VueI18n)

const locale = 'en-US' // default locale
const formatter = new Formatter({ locale })

const i18n = new VueI18n({
  locale,
  formatter,
  messages: { 'en-US': {
    message: {
      test: 'Test {num}'
    }
  } },
  missing: (locale, key, vm, values) => {
    console.error(`[Translation] missing: locale=${locale}, key=${key}, values=${JSON.stringify(values)}`)
    if (values === [] || !values[0] || !key.includes('{') || !key.includes('}')) return key
    // handle formatting manually
    try {
      return formatter.interpolate(key, values[0])[0]
    } catch (err) {
      console.error(err)
    }
    return key
  }
})

export default i18n
