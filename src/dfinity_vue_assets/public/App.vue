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
    <div>
      {{
        internetComputerGreeting ||
          "Internet Computer waiting for your firstname..."
      }}
    </div>
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
            <v-btn type="submit" color="primary" :disabled="busy">
              Ajouter
            </v-btn>
          </v-col>
        </v-row>
      </v-container>
    </v-form>
    <v-data-table
      ref="stock-table"
      :items="items"
      :headers="headers"
      item-key="name"
      :items-per-page="5"
      :loading="busy"
      loading-text="Chargement du stock en cours..."
    >
      <template v-slot:item.actions="{ item }">
        <v-icon
          v-if="isAvailable(item)"
          small
          class="mr-2"
          @click="borrowItem(item.id)"
          color="green"
          :disabled="busy"
        >
          mdi-arrow-down-circle-outline
        </v-icon>
        <v-icon
          v-else
          small
          @click="unborrowItem(item.id)"
          color="red"
          :disabled="busy"
        >
          mdi-arrow-up-circle-outline
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
        { text: "Emprunteur", value: "borrower"},
        { text: 'Actions', value: 'actions', sortable: false },
      ],
      busy: false,
    };
  },

  created() {
    this.busy = true;
    stock.getAllItems().then((items) => {
      this.items = items;
      this.busy = false;
    });
  },
  methods: {
    onSubmit() {
      dfinity_vue.greet(this.firstname).then((greeting) => {
        this.internetComputerGreeting = greeting;
      });
    },

    createItem() {
      this.busy = true;
      stock
        .createOne({ name: this.name, description: this.description })
        .then(() => stock.getAllItems())
        .then((items) => {
          console.log(items);
          this.items = items;
          this.busy = false;
        });
    },
    
    borrowItem(id) {
      this.busy = true;
      stock.borrowItem(id)
        .then(() => stock.getAllItems())
        .then((items) => {
          console.log(items);
          this.items = items;
          this.busy = false;
        });
    },
    unborrowItem(id) {
      this.busy = true;
      stock.unborrowItem(id)
        .then(() => stock.getAllItems())
        .then((items) => {
          console.log(items);
          this.items = items;
          this.busy = false;
        });
    },
    isAvailable(item) {
      return !item.borrower || item.borrower == ''
    }
  },
};
</script>
