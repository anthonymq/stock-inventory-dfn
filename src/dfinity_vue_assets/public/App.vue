<template>
  <v-app>
    <link
      href="https://cdn.jsdelivr.net/npm/@mdi/font@4.x/css/materialdesignicons.min.css"
      rel="stylesheet"
    />
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
    <v-form ref="form" @submit.prevent="createItem">
      <v-container>
        <v-row>
          <v-col cols="12" md="4">
            <v-text-field v-model="name" label="name" required></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-text-field
              v-model="description"
              label="description"
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
        internetComputerGreeting ||
          "Internet Computer waiting for your firstname..."
      }}
    </div>
    <v-data-table
      :items="items"
      :headers="headers"
      item-key="name"
      :items-per-page="5"
    >
      <template v-slot:item.borrowed="item">
        <v-simple-checkbox
          v-model="item.borrowed"
          disabled
        ></v-simple-checkbox>
      </template>
      <template v-slot:item.actions="{ item }">
      <v-icon
        small
        class="mr-2"
        @click="editItem(item)"
      >
        mdi-pencil
      </v-icon>
      <v-icon
        small
        @click="deleteItem(item)"
      >
        mdi-delete
      </v-icon>
    </template>
    </v-data-table>
  </v-app>
</template>

<script>
import dfinity_vue from "ic:canisters/dfinity_vue";
import stock from "ic:canisters/stock";

export default {
  data: () => {
    return {
      firstname: "",
      internetComputerGreeting: "",
      name: "",
      description: "",
      items: [],
      headers: [
        { text: "Nom", value: "name" },
        { text: "Description", value: "description" },
        { text: "Borrowed", value: "borrowed" },
        { text: 'Actions', value: 'actions', sortable: false },
      ],
    };
  },

  created() {
    stock.getAllItems().then((items) => (this.items = items));
  },
  methods: {
    onSubmit() {
      dfinity_vue.greet(this.firstname).then((greeting) => {
        this.internetComputerGreeting = greeting;
      });
    },

    createItem() {
      stock
        .createOne({ name: this.name, description: this.description })
        .then(() => stock.getAllItems())
        .then((items) => {
          console.log(items);
          this.items = items;
        });
    },
  },
};
</script>
