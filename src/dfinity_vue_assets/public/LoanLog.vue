<template>
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
import stock from "ic:canisters/stock";

export default {
  data: () => {
    return {
      items: [],
      headers: [
        { text: "Nom", value: "name" },
        { text: "Description", value: "description" },
        { text: "Emprunteur", value: "borrower" },
        { text: "Actions", value: "actions", sortable: false },
      ],
      busy: false,
    };
  },

  created() {
    this.busy = true;
    this.getAllItems();
  },
  methods: {
    getAllItems() {
      stock.getAllItems().then((items) => {
        console.log(items);
        this.items = items;
        this.busy = false;
      });
    },
    isAvailable(item) {
      return !item.borrower || item.borrower == "";
    },
  },
};
</script>
