import { Component, Input } from '@angular/core';
import { NgClass } from '@angular/common';

type PillVariant = 'neutral' | 'info' | 'success' | 'warn' | 'danger' | 'brand';
type PillSize = 'sm' | 'md';

@Component({
  selector: 'ui-pill',
  standalone: true,
  imports: [NgClass],
  templateUrl: './ui-pill.component.html',
  styleUrls: ['./ui-pill.component.scss']
})
export class UiPillComponent {
  @Input() className: string | string[] = '';
  @Input() variant: PillVariant = 'neutral';
  @Input() size: PillSize = 'md';

  get classes(): string[] {
    const extra = Array.isArray(this.className) ? this.className : [this.className];
    return ['ui-pill', 'pill', `v-${this.variant}`, `s-${this.size}`, ...extra].filter(Boolean) as string[];
  }
}

