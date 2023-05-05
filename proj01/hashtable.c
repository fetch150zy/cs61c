#include "hashtable.h"
#include <stdlib.h>

/*
 * This creates a new hash table of the specified size and with
 * the given hash function and comparison function.
 */
HashTable *createHashTable(int size, unsigned int (*hashFunction)(void *),
                           int (*equalFunction)(void *, void *)) {
  int i = 0;
  HashTable *newTable = malloc(sizeof(HashTable));
  newTable->size = size;
  newTable->data = malloc(sizeof(struct HashBucket *) * size);
  for (i = 0; i < size; ++i) {
    newTable->data[i] = NULL;
  }
  newTable->hashFunction = hashFunction;
  newTable->equalFunction = equalFunction;
  return newTable;
}

/*
 * This inserts a key/data pair into a hash table.  To use this
 * to store strings, simply cast the char * to a void * (e.g., to store
 * the string referred to by the declaration char *string, you would
 * call insertData(someHashTable, (void *) string, (void *) string).
 * Because we only need a set data structure for this spell checker,
 * we can use the string as both the key and data.
 */
void insertData(HashTable *table, void *key, void *data) {
  unsigned int index = table->hashFunction(key);
  struct HashBucket* new_bucket = (struct HashBucket*)malloc(sizeof(struct HashBucket));
  if (new_bucket == NULL)
    exit(EXIT_FAILURE);
  new_bucket->key = key;
  new_bucket->data = data;
  new_bucket->next = NULL;

  if (table->data[index] == NULL) {
    table->data[index] = new_bucket;
  } else {
    struct HashBucket* head = table->data[index];
    while (head->next != NULL) {
        head = head->next;
    }
    head->next = new_bucket;
  }
}

/*
 * This returns the corresponding data for a given key.
 * It returns NULL if the key is not found. 
 */
void *findData(HashTable *table, void *key) {
  unsigned int index = table->hashFunction(key);
  struct HashBucket* head = table->data[index];
  while (head != NULL) {
    if (table->equalFunction(head->key, key) == 1)
      return head->data;
    head = head->next;
  }
  return NULL;
}
