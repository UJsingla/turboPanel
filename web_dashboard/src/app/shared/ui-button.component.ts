import { Component, Input } from '@angular/core';
import { NgClass } from '@angular/common';

type BtnVariant = 'primary' | 'ghost' | 'outline';
type BtnSize = 'sm' | 'md' | 'lg';

@Component({
  selector: 'ui-btn',
  standalone: true,
  imports: [NgClass],
  templateUrl: './ui-button.component.html',
  styleUrls: ['./ui-button.component.scss']
})
export class UiButtonComponent {
  @Input() type: 'button' | 'submit' | 'reset' = 'button';
  @Input() disabled = false;
  @Input() className: string | string[] = '';
  @Input() variant: BtnVariant = 'primary';
  @Input() size: BtnSize = 'md';
  @Input() block = false;

  get classes(): string[] {
    const extra = Array.isArray(this.className) ? this.className : [this.className];
    return [
      'ui-btn',
      'btn-shared',
      `v-${this.variant}`,
      `s-${this.size}`,
      this.block ? 'block' : '',
      this.disabled ? 'is-disabled' : '',
      ...extra
    ].filter(Boolean) as string[];
  }
}

