<template>
  <v-app>
    <v-form ref="form" @submit.prevent="onSubmit">
      <v-container>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="firstname"
              label="Firstname"
              required
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-btn type="submit" color="primary">
              Send
            </v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <div>
      {{
        internetComputerGreeting || "Internet Computer waiting for your firstname..."
      }}
    </div>
  </v-app>
</template>

<script>
import dfinity_vue from "ic:canisters/dfinity_vue";

export default {
  data: () => {
    return {
      firstname: "",
      internetComputerGreeting: "",
    };
  },
  created() {},
  methods: {
    onSubmit() {
      dfinity_vue.greet(this.firstname).then((greeting) => {
        this.internetComputerGreeting = greeting;
      });
    },
  },
};
</script>
