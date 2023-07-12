import 'package:flutter/material.dart';
import 'package:pract_01/models/quotation/get_all_quotation_model.dart'
    as model_quotation;
import 'package:flutter/services.dart';
import 'package:pract_01/utils/currency_formatter.dart';

class QuotationEditItem extends StatelessWidget {
  final model_quotation.Product product;
  final int productIndex;
  final List<model_quotation.Product> products;
  final void Function(
    int productIndex,
    int sizeIndex,
    double newPrice,
    List<model_quotation.Product> updatedProducts,
  ) onPriceUpdate;

  const QuotationEditItem({
    Key? key,
    required this.product,
    required this.productIndex,
    required this.products,
    required this.onPriceUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final copiedProducts = List<dynamic>.from(products);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (product.size.isNotEmpty)
              ...product.size.asMap().entries.map((entry) {
                final sizeIndex = entry.key;
                final size = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tamaño: ${size.val}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Precio: ${CurrencyFormatter.format(size.quotationPrice as double)}'),
                              const SizedBox(width: 8),
                              Text('Cantidad: ${size.quantity}'),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Modificar precio'),
                                  content: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,2}$')),
                                      LengthLimitingTextInputFormatter(9),
                                    ],
                                    decoration: const InputDecoration(
                                      labelText: 'Nuevo precio',
                                    ),
                                    onChanged: (value) {
                                      onPriceUpdate(
                                        productIndex,
                                        sizeIndex,
                                        double.tryParse(value) ?? 0,
                                        copiedProducts
                                            .cast<model_quotation.Product>(),
                                      );
                                    },
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Modificar precio'),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            if (product.size.isEmpty)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Precio: ${CurrencyFormatter.format(product.quotationPrice as double)}'),
                        const SizedBox(width: 8),
                        Text('Cantidad: ${product.quantity}'),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Modificar precio'),
                            content: TextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}$')),
                                LengthLimitingTextInputFormatter(9),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Nuevo precio',
                              ),
                              onChanged: (value) {
                                onPriceUpdate(
                                  productIndex,
                                  -1,
                                  double.tryParse(value) ?? 0,
                                  copiedProducts
                                      .cast<model_quotation.Product>(),
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Modificar precio'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
