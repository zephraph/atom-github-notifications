"use babel";
import { defineComponent } from 'marko-widget'
import template from './template.marko';

const tag = {
  name: 'github-notifications-indicator'
};

defineComponent({
  template
})

export { tag };
