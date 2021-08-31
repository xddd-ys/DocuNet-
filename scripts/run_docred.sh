#! /bin/bash
export CUDA_VISIBLE_DEVICES=0

# -------------------DUN_BERT_base Training Shell Script--------------------
if true; then
  transformer_type=roberta
  channel_type=context-based
  if [ &transformer_type == bert ]; then
    bs=4
    bl=3e-5
    ul=(3e-4 4e-4 5e-4)
    accum=1
  elif [ &transformer_type == roberta ]; then
    type=context-based
    bs=2
    bls=(3e-5)
    ul=4e-4
    accum=2
    try=4
  fi
  for ul in ${uls[@]}
  do
  python -u ../train_balanceloss.py --data_dir ../dataset/docred \
  --channel_type $channel_type \
  --bert_lr $bl \
  --transformer_type $transformer_type \
  --model_name_or_path bert-base-cased \
  --train_file train_annotated.json \
  --dev_file dev.json \
  --test_file test.json \
  --train_batch_size $bs \
  --test_batch_size $bs \
  --gradient_accumulation_steps $accum \
  --num_labels 3 \
  --learning_rate $ul \
  --max_grad_norm 1.0 \
  --warmup_ratio 0.06 \
  --num_train_epochs 30.0 \
  --seed 66 \
  --num_class 97 \
  --save_path ../checkpoint/docred/train_bert-lr${bl}_accum${accum}_unet-lr${ul}_type_${channel_type}.pt \
  --log_dir ../logs/docred/train_bert-lr${bl}_accum${accum}_unet-lr${ul}_type_${channel_type}.log \
  --train_from_saved_model /data/lzb/DocRED/checkpoint/docred/train_roberta-lr3e-5_accum2_unet-lr4e-4_type_context-based_3.pt \
  --load_path /data/lzb/DocRED/checkpoint/docred/train_roberta-lr3e-5_accum2_unet-lr4e-4_type_context-based_3.pt
  done
fi