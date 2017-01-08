BEGIN {
  # Inicialização das variáveis (Caso contrário, acusa erro devido à possibilidade de divisão por zero).
  if_speed       = 1;
  in_ucast_pkts  = 1;
  out_ucast_pkts = 1;
}

# Tráfego de entrada
$0 ~ "iso.3.6.1.2.1.2.2.1.10." iface_idx " = " {
    if (length (in_octets[0]) == 0) {
        in_octets[0] = $4;
    } else {
        in_octets[1] = $4;
    }
}

# Tráfego de saída
$0 ~ "iso.3.6.1.2.1.2.2.1.11." iface_idx " = " {
    if (length (out_octets[0]) == 0) {
        out_octets[0] = $4;
    } else {
        out_octets[1] = $4;
    }
}

# Velocidade da interface
$0 ~ "iso.3.6.1.2.1.2.2.1.5." iface_idx " = " {
    if_speed = $4;
}

# Erros em pacotes recebidos
$0 ~ "iso.3.6.1.2.1.2.2.1.14." iface_idx " = " {
    in_errors = $4;
}

# Erros em pacotes transmitidos
$0 ~ "iso.3.6.1.2.1.2.2.1.20." iface_idx " = " {
    out_errors = $4;
}

# Pacote unicast recebidos
$0 ~ "iso.3.6.1.2.1.2.2.1.11." iface_idx " = " {
    in_ucast_pkts = $4
}

# Pacotes não-unicast recebidos
$0 ~ "iso.3.6.1.2.1.2.2.1.12." iface_idx " = " {
    in_nucast_pkts = $4
}

# Pacotes unicast transmitidos
$0 ~ "iso.3.6.1.2.1.2.2.1.17." iface_idx " = " {
    out_ucast_pkts = $4
}

# Pacotes não-unicast transmitidos
$0 ~ "iso.3.6.1.2.1.2.2.1.18." iface_idx " = " {
    out_nucast_pkts = $4
}

# Descrição do sistema
/iso.3.6.1.2.1.1.1.0 =/ {
    split ($0, descr, / = /);
    sysdescr = descr[2];
}

# Uptime - Tempo que o sistema está ligado ininterruptamente
/iso.3.6.1.2.1.1.3.0 =/ {
    uptime = $3 $4 " " $5;
}

# Nome do sistema
/iso.3.6.1.2.1.1.5.0 =/ {
    sysname = $4;
}

# Localização do sistema
/iso.3.6.1.2.1.1.6.0 =/ {
    split ($0, loc, / = /);
    location = loc[2];
}

END {
    bps            = ((((in_octets[1] - in_octets[0]) + (out_octets[1] - out_octets[0])) / mon_time) * 8) / if_speed;
    in_error_rate  = in_errors / (in_ucast_pkts + in_nucast_pkts);
    out_error_rate = out_errors / (out_ucast_pkts + out_nucast_pkts);

    print "Nome: " sysname "\nUptime:" uptime "\nTaxa de transferência: " bps " bps\nTaxa de erros de pacotes recebidos: " in_error_rate "%\nTaxa de erros de pacotes transmitidos: " out_error_rate "%\nDescrição do sistema: " sysdescr "\nLocalização:" location;
}
