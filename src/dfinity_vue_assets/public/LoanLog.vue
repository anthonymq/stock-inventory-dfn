<template>
    <v-data-table
      ref="stock-table"
      :items="items"
      :headers="headers"
      item-key="name"
      :items-per-page="20"
      :loading="busy"
      loading-text="Chargement de l'historique en cours..."
      sort-by="loanId"
      sort-desc="true"
    >
     <template v-slot:item.begin="{ item }">
      <span>{{ formatDate(item.begin) }}</span>
    </template>
     <template v-slot:item.end="{ item }">
      <span>{{ formatDate(item.end) }}</span>
    </template>
    
    </v-data-table>
</template>

<script>
import stock from "ic:canisters/stock";

export default {
  data: () => {
    return {
      items: [],
      headers: [
        { text: "Id", value: "loanId" },
        { text: "Item Id", value: "itemId" },
        { text: "Emprunteur", value: "borrowerId" },
        { text: "Début", value: "begin" },
        { text: "Fin", value: "end" },
      ],
      busy: false,
    };
  },

  created() {
    this.busy = true;
    this.getAllItems();
  },
  methods: {
    formatDate(date) {
      return (!date || date == "") ? "N/A" : new Date(date/1000000).toLocaleString();
    },
    getAllItems() {
      stock.getAllLoans().then((items) => {
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
